import utils.AccountType;


public class User {

        private String id;
        private String password;
        private AccountType accountType;

        public String getId() {
                return id;
        }

        public void setId(String id) {
                this.id = id;
        }

        public String getPassword() {
                return password;
        }

        public void setPassword(String password) {
                this.password = password;
        }

        public AccountType getAccountType() {
                return accountType;
        }

        public void setAccountType(AccountType accountType) {
                this.accountType = accountType;
        }


        public User(String id, AccountType accountType, String password) {
                this.id = id;
                this.accountType = accountType;
                this.password = password;
        }



}
