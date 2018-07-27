#include <eosiolib/eosio.hpp>
#include <eosiolib/asset.hpp>

using namespace eosio;
using std::string;

class merriment : public contract {

public:
    merriment (account_name self) : contract (self) {}

    // @abi action
    void setconfig (const account_name   _fund_source,
                    const account_name  _token_contract, 
                    const string        _token_symbol,
                    const uint8_t       _token_precision,

                    const uint16_t      _affiliate_share,
                    const uint16_t      _referrer_share,
                    const uint16_t      _sp_share,
                    const uint16_t      _disttree_share,
                    const account_name  _disttree_account,
                    
                    const uint32_t      _deposit_count,
                    const asset         _post_count_dep );

    // @abi action
    void newcountdist (const account_name    _from_account,
                        const account_name    _to_account,
                        const asset            _token_amount,
                        const uint32_t        _lower_account,
                        const uint32_t        _upper_account);
                      
    // @abi action
    void delcountdist (const uint64_t _counddist_id);

    // @abi action
    void newmaccount (const account_name _m_account,
                        const string _web_account,
                        const account_name referrer,
                        const account_name  success_partner) ;

    // @abi action
    void revenueevent (const account_name _buyer, 
                        const account_name _seller,
                        const asset _revenue ) ;


private:

    // TODO: transition to singleton
    // @abi table configs i64
    struct config {

        uint64_t        config_id;
        // basic financial config
        account_name    fund_source;
        account_name    token_contract;
        symbol_type     token_symbol;

        // revenue share config
        uint16_t        affiliate_share;
        uint16_t        referrer_share;
        uint16_t        sp_share;
        uint16_t        disttree_share;
        account_name    disttree_account;

        // new account deposit info
        uint32_t        deposit_count;
        asset           post_count_dep;

        // calculated field 
        uint32_t        user_count;

        uint64_t    primary_key() const { return config_id; }

        EOSLIB_SERIALIZE (config, (config_id)(fund_source)(token_contract)(token_symbol)
                                    (affiliate_share)(referrer_share)(sp_share)(disttree_share)(disttree_account)
                                   (deposit_count)(post_count_dep)(user_count));
    };

    typedef eosio::multi_index<N(configs), config> config_table;

    // @abi table maccounts i64
    struct maccount {
        account_name    m_account;
        string          web_account;
        account_name    referrer;
        account_name    success_partner;

        account_name    primary_key() const { return m_account; }

        EOSLIB_SERIALIZE (maccount, (m_account)(web_account)(referrer)(success_partner));
    };

    typedef eosio::multi_index<N(maccounts), maccount> maccount_table;

    // @abi table countdists i64
    struct countdist {
        uint64_t        countdist_id;
        account_name    from_account;
        account_name    to_account;
        asset           token_amount;
        uint32_t        lower_account;
        uint32_t        upper_account;

        uint64_t    primary_key() const { return countdist_id; }

        EOSLIB_SERIALIZE (countdist, (countdist_id)(from_account)(to_account)(token_amount)
                                        (lower_account)(upper_account));
    };

    typedef eosio::multi_index<N(countdists), countdist> countdist_table;


    void transfer(const account_name from,
                  const account_name to,
                  const asset token_amount,
                  const string memo)
    {

        config_table config(_self, _self);
        auto itr = config.begin();
        eosio_assert(itr != config.end(), "token contract is not set");

        print("---------- Transfer -----------\n");
        print("Token Contract:   ", name{itr->token_contract}, "\n");
        print("From:             ", name{from}, "\n");
        print("To:               ", name{to}, "\n");
        print("Amount:           ", token_amount, "\n");

        action(
            permission_level{from, N(active)},
            itr->token_contract, N(transfer),
            std::make_tuple(from, to, token_amount, memo))
            .send();

        print("---------- End Transfer -------\n");
    }

};

EOSIO_ABI (merriment, (setconfig)(newcountdist)(delcountdist)(newmaccount)(revenueevent))