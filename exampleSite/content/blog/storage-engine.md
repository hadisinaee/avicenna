+++
title = 'What a storage engine taught me'
date = 2025-12-08
description = 'Durability, indexes, and the importance of recovery.'
tags = ['storage']
+++
Building a small storage engine makes the tradeoffs visible: durability has a cost, indexes need maintenance, and recovery deserves as much attention as the happy path.

## Make the invariants explicit

Before optimizing a write, describe exactly when it becomes durable and what a reader is allowed to observe.
