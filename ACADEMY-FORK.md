# ACADEMY-FORK.md — AutomatedTechnologies/macvim

- **Upstream repo:** macvim-dev/macvim — https://github.com/macvim-dev/macvim
- **Original authors, as the upstream states them** (`src/MacVim/Credits.rtf`):
  Vim — created by Bram Moolenaar; currently maintained by The Vim Project
  (https://github.com/orgs/vim/people). MacVim GUI — created by Björn
  Winckler; currently maintained by MacVim Developers
  (https://github.com/orgs/macvim-dev/people).
- **License:** Vim License (SPDX `Vim`) — see `LICENSE` at the root of this
  repository, unmodified. The Vim license expressly permits distribution of
  modified versions; the Academy build line distributes under clause II.2.c
  (all Academy changes are published as source in this fork) and II.3 (the
  build carries `--with-modified-by="Detroit Automation Academy"`, shown in
  the `:version` output and intro screen).
- **Fork point (repository):** upstream `master` HEAD at acquisition,
  `519a8c45aa719e0bba92c6391119f11cfa370ab7`.
- **Academy build base:** upstream tag `release-184`,
  `287a5cf3d5727e0c15882d1df9d0c3a6c3882fcb` — the last main-line MacVim
  release whose published binary targets macOS 10.13 (upstream's own CI at
  that tag builds with `MACOSX_DEPLOYMENT_TARGET 10.13`; release-184's
  notes announce that the next release requires macOS 12.0+ and moves
  10.13–11.0 to a legacy build). Academy build work lives on the
  `build-test` branch cut from that tag.
- **Date:** 2026-11-12.
- Acquired by the Detroit Automation Academy under the assimilation quality
  standard (Distro goal `files/16`) for preservation and possible uplift,
  on the owner's named directive of 2026-11-12 ("VIM GUI shell, build to
  V5 standard"); the upstream license governs the code. QS record and
  architecture decision: Distro goal `files/34`.
- The Academy product built from this fork ships as **Compositor**
  (bundle `com.detroitautomationacademy.compositor`) through Distro.
  "Vim" and "MacVim" remain the upstream project's names and are retained
  in provenance and in internal identifiers that are plumbing, not
  identity (target and scheme names, `MM*` classes, `org.vim.*` UTIs).
