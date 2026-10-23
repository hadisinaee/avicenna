+++
title = 'The case for boring infrastructure'
date = 2026-01-15
description = 'Familiar components leave room to think about the problem that matters.'
tags = ['infrastructure', 'engineering']
toc = true
+++
Good infrastructure leaves room to think about the problem you actually want to solve.

That often means choosing familiar components, keeping the number of moving parts small, and making failures easy to explain.

<!--more-->

## Start with one clear path

A useful system should be understandable from its simplest working configuration. Add complexity when a measured limitation makes it necessary.

```sh
hugo server --source exampleSite
```

## Make failures visible

Prefer an actionable error over a silent fallback. Configuration mistakes should be easy to find before deployment.

> The simplest working system is a useful starting point.

| Decision | Starting point |
| --- | --- |
| Content | Markdown |
| Styling | Plain CSS |
| Publishing | Static HTML |

## Keep the contract small

Three appearance settings are enough to establish a consistent identity: a primary font, a secondary font, and a color theme.
