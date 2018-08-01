#include <merriment.hpp>
#include <string>
#include <eosiolib/print.hpp>

#include <iostream>


void merriment::revenueevent (const uint64_t        _config_id, 
                              const account_name    _buyer, 
                              const account_name    _seller, 
                              const asset           _revenue,
                              const account_name    _publisher,
                              const uint16_t        _publisher_sharex100) {

    maccount_table m_t (_self, _self);
    auto account_index = m_t.get_index<N (m_account)> ();
    auto b_itr = account_index.find (_buyer);
    eosio_assert (b_itr != account_index.end(), "Buyer account not found.");

    auto s_itr = account_index.find (_seller);
    eosio_assert (s_itr != account_index.end(), "Seller account not found.");

    config_table config (_self, _self);
    auto c_itr = config.find(_config_id);
    eosio_assert (c_itr != config.end(), "Configuration ID not found.");

    auto account_age = now() - b_itr->created_date;
    if (account_age <= c_itr->onboarding_days * 60 * 60 * 24) {
        transfer (_buyer, b_itr->referrer, _revenue * c_itr->ob_referrer_sharex100 / 10000, "Referral Payment (w/ Onboarding Discount)");
        transfer (_buyer, b_itr->success_partner, _revenue * c_itr->ob_sp_sharex100 / 10000, "Success Partner Payment (w/ Onboarding Discount");
        transfer (_buyer, s_itr->referrer, _revenue * c_itr->ob_referrer_sharex100 / 10000, "Referral Payment (w/ Onboarding Discount)");
        transfer (_buyer, s_itr->success_partner, _revenue * c_itr->ob_sp_sharex100 / 10000, "Success Partner Payment (w/ Onboarding Discount");
        transfer (_buyer, c_itr->disttree_account, _revenue * c_itr->ob_disttree_sharex100 / 10000, "Revenue Auto-Distribution (w/ Onboarding Discount)");
        
        // transfer to publisher
        if (_publisher != 0 && _publisher_sharex100 > 0) {
            asset affiliate_amount = _revenue * c_itr->ob_affiliate_sharex100 / 10000;
            asset publisher_amount = affiliate_amount * _publisher_sharex100 / 10000;
            affiliate_amount = affiliate_amount - publisher_amount;
            transfer (_buyer, _publisher, publisher_amount, "Merriment Publisher Payment");
            transfer (_buyer, _seller, affiliate_amount, "Merriment Affiliate Payment (w/ Onboarding Discount)");
        } else {
            transfer (_buyer, _seller, _revenue * c_itr->ob_affiliate_sharex100 / 10000, "Merriment Affiliate Payment (w/ Onboarding Discount)");
        }
    } 
    else {
        transfer (_buyer, b_itr->referrer, _revenue * c_itr->referrer_sharex100 / 10000, "Referral Payment");
        transfer (_buyer, b_itr->success_partner, _revenue * c_itr->sp_sharex100 / 10000, "Success Partner Payment");
        transfer (_buyer, s_itr->referrer, _revenue * c_itr->referrer_sharex100 / 10000, "Referral Payment");
        transfer (_buyer, s_itr->success_partner, _revenue * c_itr->sp_sharex100 / 10000, "Success Partner Payment");
        transfer (_buyer, c_itr->disttree_account, _revenue * c_itr->disttree_sharex100 / 10000, "Revenue Auto-Distribution");

        // transfer to publisher
        if (_publisher != 0 && _publisher_sharex100 > 0) {
            asset affiliate_amount = _revenue * c_itr->affiliate_sharex100 / 10000;
            asset publisher_amount = affiliate_amount * _publisher_sharex100 / 10000;
            affiliate_amount = affiliate_amount - publisher_amount;
            print ("Publisher Amount: ", publisher_amount, "\n");
            print ("Affiliate Amount: ", affiliate_amount, "\n");
            transfer (_buyer, _publisher, publisher_amount, "Merriment Publisher Payment");
            transfer (_buyer, _seller, affiliate_amount, "Merriment Affiliate Payment");
         } else {
            transfer (_buyer, _seller, _revenue * c_itr->affiliate_sharex100 / 10000, "Merriment Affiliate Payment");
        }
    } 
}

void merriment::addconfig (const account_name   _fund_source,
                            const account_name  _token_contract, 
                            const string        _token_symbol,
                            const uint8_t       _token_precision,

                            const uint16_t      _onboarding_days,
                            const uint16_t      _ob_affiliate_sharex100,
                            const uint16_t      _ob_referrer_sharex100,
                            const uint16_t      _ob_sp_sharex100,
                            const uint16_t      _ob_disttree_sharex100,

                            const uint16_t      _affiliate_sharex100,
                            const uint16_t      _referrer_sharex100,
                            const uint16_t      _sp_sharex100,
                            const uint16_t      _disttree_sharex100,
                            const account_name  _disttree_account,
                            
                            const uint32_t      _deposit_count,
                            const asset         _post_count_dep ) {

    config_table config (_self, _self);
    config.emplace (_self, [&](auto& c) {
        c.config_id         = config.available_primary_key();
        c.fund_source       = _fund_source;
        c.token_contract    = _token_contract;
        c.token_symbol      =  string_to_symbol(_token_precision, _token_symbol.c_str());
        c.onboarding_days   = _onboarding_days;
        c.ob_affiliate_sharex100 = _ob_affiliate_sharex100;
        c.ob_referrer_sharex100 = _ob_referrer_sharex100;
        c.ob_sp_sharex100       = _ob_sp_sharex100;
        c.ob_disttree_sharex100  = _ob_disttree_sharex100;
        c.affiliate_sharex100   = _affiliate_sharex100;
        c.referrer_sharex100    = _referrer_sharex100;
        c.sp_sharex100          = _sp_sharex100;
        c.disttree_sharex100    = _disttree_sharex100;
        c.disttree_account  = _disttree_account;
        c.deposit_count     = _deposit_count;
        c.post_count_dep    = _post_count_dep;
    });

    print ("Configuration set\n");
}

void merriment::newcountdist (const account_name        _from_account,
                                const account_name      _to_account,
                                const asset             _token_amount,
                                const uint32_t          _lower_account,
                                const uint32_t          _upper_account) {

    eosio_assert (_lower_account < _upper_account, "Invalid config: lower bound must be lower than upper bound");

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

void merriment::newmaccount (const uint64_t     _config_id,
                            const account_name  _m_account,
                            const string        _web_account,
                            const account_name  _referrer,
                            const account_name  _success_partner,
                            const uint8_t       _account_type) {

    
    maccount_table m_t (_self, _self); 
    uint64_t account_count = 0;
    m_t.emplace (_self, [&](auto& ma) {
        ma.account_id       = m_t.available_primary_key();
        account_count       = ma.account_id + 1;
        ma.m_account        = _m_account;
        ma.web_account      = _web_account;
        ma.referrer         = _referrer;
        ma.success_partner  = _success_partner;
        ma.account_type     = _account_type;
        ma.created_date     = now();
    });

    config_table config (_self, _self);
    auto c_itr = config.find(_config_id);
    eosio_assert (c_itr != config.end(), "Configuration ID not found.");
       
    if (account_count > c_itr->deposit_count) {
        // after user_count threshold for deposits, so deposit
        transfer (c_itr->fund_source, _m_account, c_itr->post_count_dep, "New Merriment User");
    }

    countdist_table cd_t (_self, _self);
    auto cd_itr = cd_t.begin();
    while (cd_itr != cd_t.end()) {
        if (account_count > cd_itr->lower_account && account_count <= cd_itr->upper_account) {
            transfer (cd_itr->from_account, cd_itr->to_account, cd_itr->token_amount, "User count: " + std::to_string(account_count));
        }
        cd_itr++;
    }
    print ("Insert accont\n");
}