#include <dist.hpp>

#include <eosiolib/asset.hpp>
#include <eosiolib/action.hpp>
#include <iostream>

//using namespace std;

void distrib::init (const account_name _token_contract,
                    const asset         _example_asset) {

    eosio_assert (!isInit(), "Configuration has already been set.");
    parent_table p_table (_self, _self);
    p_table.emplace (_self, [&](auto& a) {
        a.parent_acct    = _self;
        a.parent_name    = DEFAULT_ACCOUNT;
        a.parent_share   = 100;
    });

    config_table config (_self, _self);
    config.emplace (_self, [&](auto& c) {
        c.token_contract = _token_contract;
        c.example_asset = _example_asset;
    });
}

//TODO: Add asset to the set contract function
void distrib::setcontract (const account_name _token_contract) {
    config_table config (_self, _self);
    auto itr = config.begin();
    config.modify (itr, _self, [&](auto& c) {
        c.token_contract = _token_contract;
    });
}

void distrib::foo() {} 

void distrib::distribute () {

    parent_table p_table (_self, _self);
    child_table c_table (_self, _self);

    asset balance_to_dist = get_balance (_self);

    auto p_itr = p_table.begin();
    while (p_itr != p_table.end()) {
        if (p_itr->parent_acct == _self) { p_itr++; continue; }

        auto p_xfer_amount = p_itr->parent_share * balance_to_dist / 10000;
        transfer (_self, p_itr->parent_acct, p_xfer_amount, "auto distribution");

        auto parent_index = c_table.get_index<N (parent_acct)> ();
        auto c_itr = parent_index.find (p_itr->parent_acct);
        while (c_itr != parent_index.end() && c_itr->parent_acct == p_itr->parent_acct) {
            auto c_xfer_amount = c_itr->share * p_xfer_amount / 10000;
            transfer (p_itr->parent_acct, c_itr->child_acct, c_xfer_amount, "auto distribution");
            c_itr++;
        }
        p_itr++;
    }
}

void distrib::delall () {

    parent_table p_table (_self, _self);
    auto itr = p_table.begin();
    while (itr != p_table.end()) {
       itr = p_table.erase (itr);
    }

    child_table c_table (_self, _self);
    auto c_itr = c_table.begin();
    while (c_itr != c_table.end()) {
        c_itr = c_table.erase (c_itr);
    }

    print ("Distributions configuration reset.");
}

void distrib::addparent ( const string       _parentname,
                          const account_name  _parentacct,
                          const uint16_t      _dist_percx100 ) {

    eosio_assert (isInit(), "Contract must first be initialized by calling init.");
    eosio_assert (_dist_percx100 > 0, "Requested percent must be greater than 0.");
    eosio_assert (_dist_percx100 <= 100, "Requested percent must be less than or equal to 100.");
    eosio_assert (_parentname.compare(DEFAULT_ACCOUNT) != 0, "Invalid name: cannot use DEFAULT ACCOUNT.");
        
    parent_table p_table (_self, _self);
    auto itr = p_table.begin();

    // ensure distribution parent does not already exist
    while (itr != p_table.end()) {
        eosio_assert (_parentname.compare(itr->parent_name) != 0, "Distribution parent already exists.");
        if (itr->parent_name.compare (DEFAULT_ACCOUNT) == 0) {
            eosio_assert (itr->parent_share >= _dist_percx100, "Requested percent is too high (greater than balance of default account)");
            p_table.modify (itr, _self, [&](auto& p) {
                p.parent_share = p.parent_share - _dist_percx100;
            });
        }
        itr++;
    }
    
    p_table.emplace (_self, [&](auto& p) {
        p.parent_acct    = _parentacct;
        p.parent_name    = _parentname;
        p.parent_share   = _dist_percx100;
    });

    print (_parentname, " parent added.");
}


 void distrib::removeparent (const string _parentname ) {

    eosio_assert (isInit(), "Contract must first be initialized by calling init.");
    eosio_assert (_parentname.compare(DEFAULT_ACCOUNT) != 0, "Invalid name: cannot remove DEFAULT ACCOUNT parent.");

    parent_table p_table (_self, _self);
        
    auto p_itr = p_table.begin();
    while (p_itr != p_table.end() && _parentname.compare (p_itr->parent_name) != 0) {
        p_itr++;
    }
    eosio_assert (p_itr != p_table.end(), "Parent not found.");

    auto default_itr = p_table.begin();
    while (default_itr != p_table.end() || default_itr->parent_name.compare (DEFAULT_ACCOUNT) == 0) {
        if (default_itr->parent_name.compare (DEFAULT_ACCOUNT) == 0) {
            p_table.modify (default_itr, _self, [&](auto& p) {
                p.parent_share = p.parent_share + p_itr->parent_share;
            });
        }
        default_itr++;
    }

    p_itr = p_table.erase (p_itr);

    print (_parentname, " parent removed.");
 }
 

void distrib::addchild (  const account_name     _parentacct, 
                             const account_name  _childacct,
                             const uint16_t      _percx100) {
    
    eosio_assert (isInit(), "Contract must first be initialized by calling init.");
    eosio_assert (_percx100 > 0, "Requested percent must be greater than 0.");
    eosio_assert (_percx100 <= 100, "Requested percent must be less than or equal to 100.");

    parent_table p_table (_self, _self);
    auto itr = p_table.find(_parentacct);
    eosio_assert (itr != p_table.end(), "Parent account not found.");
    
    child_table c_table (_self, _self);
    auto parent_index = c_table.get_index<N (parent_acct)> ();
    auto c_itr = parent_index.lower_bound(_parentacct);
    uint16_t    running_perc {0};

    while (c_itr != parent_index.end() && _parentacct == c_itr->parent_acct) {
        running_perc += c_itr->share;   
        c_itr++;
    }

    eosio_assert (_percx100 <= 100 - running_perc, "Requested percent is too high (parent's config is greater than 100).");

    c_table.emplace (_self, [&](auto &c) {
        c.child_id      = c_table.available_primary_key();
        c.child_acct    = _childacct;
        c.share         = _percx100;
        c.parent_acct   = _parentacct;
    });
 }

 void distrib::removecldpar (const account_name   _parentacct, 
                            const account_name    _childacct) {

    child_table c_table (_self, _self);
    auto child_index = c_table.get_index<N (child_acct)> ();

    auto c_itr = child_index.find(_childacct);

    while (c_itr != child_index.end()) {
        if (_parentacct == c_itr->parent_acct) {
            c_itr = child_index.erase (c_itr);
        }
        else {
            c_itr++;
        }
    }
 }

void distrib::removechild (const account_name    _childacct) {

    child_table c_table (_self, _self);
    auto child_index = c_table.get_index<N (child_acct)> ();

    auto c_itr = child_index.find(_childacct);

    while (c_itr != child_index.end()) {
        c_itr = child_index.erase (c_itr);
    }
 }