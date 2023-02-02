syslog-ng via TLS connections

# How to test?

1. `vagrant up`

2. ssh to demo server

    ```console
    vagrant ssh
    ```

3. generate CA for both client and server

    ```console
    cd /vagrant
    make setup-syslog-ng-key
    ```

4. start syslog-ng server

    ```console
    cd /vagrant
    make run-syslog-ng
    ```

    received log from client would be persisted in `/tmp/log/syslog`

4. open up another terminal and ssh to demo server as step.2

5. quick test syslog-ng server with loggen to make sure syslog-ng is ready to serve

    ```console
    cd /vagrant
    make run-loggen-tcp-client
    ```

6. test syslog-ng server with golang

    ```console
    cd /vagrant
    make run-syslog-go-client
    ```

# References

* [如何使用 OpenSSL 簽發中介 CA](https://blog.davy.tw/posts/use-openssl-to-sign-intermediate-ca/)