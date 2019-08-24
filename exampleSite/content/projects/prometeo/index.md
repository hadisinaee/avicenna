---
title: "Prometeo"
date: 2019-08-19T17:41:27+02:00
draft: false
---

# Prometeo Desktop

Prometeo is a Windows desktop application, wrote in C#. It allows its user to exchange files and folders across the LAN in a peer-to-peer architectural model.
Every user in the network that has the application can act both as a client and as a server.
The actual exchange of data involves two stages. Initially, an UDP-based communication protocol is used to search other peers on the LAN, as well as to periodically signal its own presence.
Then, a TCP-based transfer protocol performs the exchange in a similar but simplified way as FTP protocol does.
