# Introduction to Programming for Data Analysis

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/3wen/intro-r/blob/main/LICENSE)
[![R](https://img.shields.io/badge/R-Programming-276DC3)](#)
[![Repo](https://img.shields.io/badge/GitHub-3wen%2Fintro--r-181717?logo=github)](https://github.com/3wen/intro-r)

Course materials (lecture notes, tutorials, and hints) for the **Introduction to Programming for Data Analysis** course, taught in the first year of the Master in Economics program (Semester 1) at **Aix-Marseille Université (amU)**.

## Table of Contents

- [About](#about)
- [Course Content](#course-content)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Building the Documents](#building-the-documents)
- [Usage](#usage)
- [Contributing](#contributing)
- [Authors](#authors)
- [License](#license)

## About

This repository ([3wen/intro-r](https://github.com/3wen/intro-r)) contains the teaching material for a Master-level course introducing students to programming (primarily in R) applied to data analysis, data wrangling, data visualization, and statistical inference. Material is authored in **LaTeX** (`.tex`) and **Quarto** (`.qmd`), with a companion dataset and a shared bibliography (`references.bib`).

## Course Content

The course is organized into **lecture sessions ("séances")** and **tutorials**:

| Folder | Description |
|---|---|
| `session-1/` | Introduction, the R programming language and programming software, core concepts |
| `session-2/` | Lecture session 2 |
| `session-3/` | Lecture session 3 |
| `session-4/` | Lecture session 4 |
| `tutorials/` | Tutorial #1 (Data Management and Data Wrangling), #2 (Data Visualization and Summary Statistics), #3 (Linear Regressions and Statistical Tests) |

Each tutorial includes a `\ifcorrection` toggle in the LaTeX source, allowing instructors to compile either:
- a **student handout** (solutions hidden), or
- an **answer key** (solutions shown).

## Repository Structure

```
.
├── assets/                     # Shared LaTeX style files, logos, and static assets
├── data/
│   └── deces_france_insee/     # INSEE death-records dataset used in tutorials/exercises
├── figs/                       # Figures used across sessions and tutorials
├── session-1/                  # Lecture 1: Intro & R basics
├── session-2/                  # Lecture 2
├── session-3/                  # Lecture 3
├── session-4/                  # Lecture 4
├── tutorials/                  # Tutorials 1–3 (Quarto sources)
│   ├── tutorial-1.qmd          # Tutorial 1: Data Management and Data Wrangling
│   ├── tutorial-2.qmd          # Tutorial 2: Data Visualization and Summary Statistics
│   └── tutorial-3.qmd          # Tutorial 3: Linear Regressions and Statistical Tests
├── intro-r.Rproj               # RStudio project file
├── references.bib              # Bibliography used across the course material
├── .gitignore
└── LICENSE                     # GPL-3.0
```

> **Note:** The `.tex` files reference the `assets/` folder (e.g. `assets/style-td`, `assets/figs/...`) for shared styles and logos, and some tutorials use data from `data/deces_france_insee/`. Keep these folders alongside the source files when compiling.

## Authors

- **U. Aiounou** — dimitri.aiounou [at] univ-amu.fr
- **E. Gallic** — ewen.gallic [at] univ-amu.fr
- **K. Kouadio** — kla.kouadio [at] univ-amu.fr
- **M. Raux** — morgan.raux [at] univ-amu.fr

*Master in Economics, 1st Year — Semester 1, Aix-Marseille Université*

## License

This project is licensed under the **GNU General Public License v3.0** — see the [LICENSE](LICENSE) file for details.
