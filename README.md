To find a common way to get source IP no matter direct connection, via forward proxy, via MITM proxy, or NAT

# How to test?

1. `vagrant up`

2. ssh to demo server

    ```console
    vagrant ssh
    ```

3. start syslog-ng server

    ```console
    cd /vagrant
    make run-syslog-ng-tcp
    ```

    received log from client would be persisted in `/tmp/log/syslog`

4. open up another terminal and ssh to demo server as step.2

5. quick test syslog-ng server with loggen to make sure syslog-ng is ready to serve

    ```console
    cd /vagrant
    make run-loggen-tcp
    ```

6. test syslog-ng server with golang via tcp

    ```console
    cd /vagrant
    make run-syslog-client-tcp
    ```

# References

* [如何使用 OpenSSL 簽發中介 CA](https://blog.davy.tw/posts/use-openssl-to-sign-intermediate-ca/)