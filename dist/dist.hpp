#include <eosiolib/eosio.hpp>
#include <eosiolib/singleton.hpp>
#include <eosiolib/asset.hpp>
#include <../eosio.token/eosio.token.hpp>

using namespace eosio;
using std::string;

class distrib : public contract
{
  public:
    distrib(account_name self) : contract(self) {}

    // @abi action
    void foo();

    // @abi action
    void setcontract (const account_name _token_contract, 
                        const string _token_symbol, 
                        const uint8_t  _token_precision);

    // @abi action
    void init(const account_name _token_contract,
                const string _token_symbol,
                const uint8_t   _token_precision);

    // @abi action
    void delall();

    // // @abi action
    void distribute();

    // @abi action
    void addparent(const string _parentname,
                   const account_name _parentacct,
                   const uint16_t _dist_percx100);

    // @abi action
    void pauseparent (const account_name    _parentacct);

    // @abi action
    void unpausepar (const account_name     _parentacct);
    
    // @abi action
    void removeparent(const string _parentname);

    // @abi action
    void removeparact(const account_name _parentacct);

    // @abi action
    void addchild(const account_name _parent_acct,
                  const account_name _childacct,
                  const uint16_t _percx100);

    // @abi action
    void removecldpar(const account_name _parentacct,
                      const account_name _childacct);

    // @abi action
    void removechild(const account_name _childacct);
   
  private:
    // @abi table configs i64
    struct config
    {
        uint64_t        config_id;
        account_name    token_contract;
        symbol_type     token_symbol;
        account_name    primary_key() const { return token_contract; }

        EOSLIB_SERIALIZE(config, (config_id)(token_contract)(token_symbol));
    };

    typedef eosio::multi_index<N(configs), config> config_table;

    // this struct is only used to access the users' EVA balance
    struct account
    {
        asset balance;

        uint64_t primary_key() const { return balance.symbol.name(); }
    };

    typedef eosio::multi_index<N(accounts), account> accounts;
    
    // @abi table children i64
    struct child
    {
        uint64_t child_id;
        account_name child_acct;
        uint16_t share;
        account_name parent_acct;

        uint64_t primary_key() const { return child_id; }
        account_name bychild() const { return child_acct; }
        account_name byparent() const { return parent_acct; }

        EOSLIB_SERIALIZE(child, (child_id)(child_acct)(share)(parent_acct));
    };

    typedef eosio::multi_index<N(children), child,
                               indexed_by<N(child_acct),
                                          const_mem_fun<child, account_name, &child::bychild>>,
                               indexed_by<N(parent_acct),
                                          const_mem_fun<child, account_name, &child::byparent>>>
                        child_table;

    // @abi table parents i64
    struct parent
    {
        account_name parent_acct;
        string parent_name;
        uint16_t parent_share;
        uint8_t    paused;

        account_name primary_key() const { return parent_acct; }

        EOSLIB_SERIALIZE(parent, (parent_acct)(parent_name)(parent_share)(paused))
    };

    typedef eosio::multi_index<N(parents), parent> parent_table;

    const string DEFAULT_ACCOUNT = "default";
    const uint8_t PAUSED = 1;
    const uint8_t UNPAUSED = 0;
    
    bool isInit()
    {
        parent_table p_table(_self, _self);
        auto itr = p_table.begin();

        while (itr != p_table.end())
        {
            if (itr->parent_name.compare(DEFAULT_ACCOUNT) == 0)
            {
                return true;
            }
            itr++;
        }
        return false;
    }

    account_name getDefault()
    {
        parent_table p_table(_self, _self);
        auto itr = p_table.begin();

        while (itr != p_table.end())
        {
            if (itr->parent_name.compare(DEFAULT_ACCOUNT) == 0)
            {
                return itr->parent_acct;
            }
            itr++;
        }
        return 0;
    }

    asset get_balance(const account_name account)
    {
        config_table config(_self, _self);
        auto itr = config.begin();
        eosio_assert(itr != config.end(), "token contract is not set");

        accounts accountstable(itr->token_contract, account);
        auto itr_a = accountstable.begin();

        while (itr_a != accountstable.end() && itr_a->balance.symbol != itr->token_symbol) {
            itr_a++;
        }

        return itr_a->balance;
    }

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

EOSIO_ABI(distrib, (init)(distribute)(setcontract)(delall)(addparent)(removeparent)
            (addchild)(removecldpar)(removechild)(removeparact)
            (pauseparent)(unpausepar))