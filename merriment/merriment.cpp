#include <merriment.hpp>
#include <string>

void merriment::revenueevent (const account_name _buyer, 
                              const account_name _seller, 
                              const asset        _revenue) {

    maccount_table m_t (_self, _self);
    auto b_itr = m_t.find (_buyer);
    eosio_assert (b_itr != m_t.end(), "Buyer account not found.");

    auto s_itr = m_t.find (_seller);
    eosio_assert (s_itr != m_t.end(), "Seller account not found.");

    config_table config (_self, _self);
    auto c_itr = config.begin();

    //auto pass_thru = 100 - c_itr->affiliate_share - c_itr->referrer_share - c_itr->sp_share - c_itr->disttree_share;

    print ("Revenue :  ", _revenue, "\n");
    //print ("Referral Share : ", std::to_string(c_itr->referrer_share), "\n");
    print ("Referral Amount: ", c_itr->referrer_share * _revenue / 100, "\n");
    //print ("Success Partner Share : ", std::to_string(c_itr->sp_share), "\n");
    print ("Success Partner Amount: ", c_itr->sp_share * _revenue / 100, "\n");

    //print ("Pass thru Share : ", std::to_string(pass_thru), "\n");
    //print ("Pass thru Amount: ", pass_thru * _revenue / 100, "\n");

    transfer (_buyer, b_itr->referrer, c_itr->referrer_share * _revenue / 100, "Referral Payment");
    transfer (_buyer, b_itr->success_partner, c_itr->sp_share * _revenue / 100, "Success Partner Payment");
    transfer (_buyer, c_itr->disttree_account, c_itr->disttree_share * _revenue / 100, "Revenue Auto-Distribution");
    transfer (_buyer, _seller, c_itr->affiliate_share * _revenue / 100, "Merriment Affiliate Payment");
}

void merriment::setconfig (const account_name   _fund_source,
                            const account_name  _token_contract, 
                            const string        _token_symbol,
                            const uint8_t       _token_precision,

                            const uint16_t      _affiliate_share,
                            const uint16_t      _referrer_share,
                            const uint16_t      _sp_share,
                            const uint16_t      _disttree_share,
                            const account_name  _disttree_account,
                            
                            const uint32_t      _deposit_count,
                            const asset         _post_count_dep ) {

    config_table config (_self, _self);
    config.emplace (_self, [&](auto& c) {
        c.config_id         = config.available_primary_key();
        c.fund_source       = _fund_source;
        c.token_contract    = _token_contract;
        c.token_symbol      =  string_to_symbol(_token_precision, _token_symbol.c_str());
        c.affiliate_share   = _affiliate_share;
        c.referrer_share    = _referrer_share;
        c.sp_share          = _sp_share;
        c.disttree_share    = _disttree_share;
        c.disttree_account  = _disttree_account;
        c.deposit_count     = _deposit_count;
        c.post_count_dep    = _post_count_dep;
    });

}


void merriment::newcountdist (const account_name    _from_account,
                                const account_name    _to_account,
                                const asset           _token_amount,
                                const uint32_t        _lower_account,
                                const uint32_t        _upper_account) {

    eosio_assert (_lower_account < _upper_account, "Invalid config: lower bound must be lower than upper bound");

    print ("Adding record to newcountdist");

    countdist_table cd_t (_self, _self);
    cd_t.emplace (_self, [&](auto& cd) {
        cd.countdist_id = cd_t.available_primary_key();
        cd.from_account = _from_account;
        cd.to_account   = _to_account;
        cd.token_amount = _token_amount;
        cd.lower_account    = _lower_account;
        cd.upper_account    = _upper_account;
    });

}

void merriment::delcountdist (const uint64_t _countdist_id) {
    countdist_table cd_t (_self, _self);
    auto itr = cd_t.find (_countdist_id);
    eosio_assert (itr != cd_t.end(), "Count distribution ID not found");
    cd_t.erase (itr);
}


void merriment::newmaccount (const account_name _m_account,
                            const string        _web_account,
                            const account_name  _referrer,
                            const account_name  _success_partner) {

    config_table config (_self, _self);
    auto itr = config.begin();
    config.modify (itr, _self, [&](auto& c) {
        c.user_count++;
    });

    if (itr->user_count > itr->deposit_count) {
        // after user_count threshold for deposits, so deposit
        transfer (itr->fund_source, _m_account, itr->post_count_dep, "New Merriment User");
    }

    countdist_table cd_t (_self, _self);
    auto cd_itr = cd_t.begin();
    while (cd_itr != cd_t.end()) {
        if (itr->user_count > cd_itr->lower_account && itr->user_count <= cd_itr->upper_account) {
            transfer (cd_itr->from_account, cd_itr->to_account, cd_itr->token_amount, "User count: " + std::to_string(itr->user_count));
        }
        cd_itr++;
    }

    maccount_table m_t (_self, _self);
    m_t.emplace (_self, [&](auto& ma) {
        ma.m_account        = _m_account;
        ma.web_account      = _web_account;
        ma.referrer         = _referrer;
        ma.success_partner  = _success_partner;
    });
}