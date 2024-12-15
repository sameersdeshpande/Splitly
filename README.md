# Splitty - A Simple Expense Splitter App

**Splitty** is a simple, user-friendly iOS app built with **SwiftUI** and **SQLite** that helps you easily split bills and track shared expenses with friends, family, or colleagues. Whether you're at a restaurant, on a trip, or just sharing any group expense, Splitty ensures everyone knows exactly how much they owe.

---

## Features

- **Split Expenses**: Add items to a group bill and split the total cost among multiple participants.
- **Multiple Participants**: Add as many participants as needed and track individual amounts.
- **Customizable Splits**: Split the costs equally or adjust individual contributions.
- **Real-time Updates**: The app dynamically updates the total and individual balances as you add, remove, or adjust expenses.
- **Tax & Tip Support**: Automatically calculate taxes and tips and distribute them across the participants.
- **Currency Support**: Choose from different currencies for international usage.
- **Simple and Intuitive UI**: Clean, modern design with a straightforward user interface that makes splitting bills easy.

---

## Screenshots

Here’s a preview of what Splitty looks like:

![Screenshot 1](path-to-screenshot1.png)  
![Screenshot 2](path-to-screenshot2.png)

---

## Tech Stack

We used the following technologies to build **Splitty**:

| Technology       | Logo | Description |
|------------------|------|-------------|
| **SwiftUI**      | ![SwiftUI Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Swift_logo%2C_SW.png/600px-Swift_logo%2C_SW.png) | For building the app’s modern and responsive user interface. |
| **SQLite**       | ![SQLite Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/SQLite370.svg/1200px-SQLite370.svg.png) | For managing persistent storage of expenses and participants data. |
| **SQLite.swift** | ![SQLite.swift Logo](https://avatars.githubusercontent.com/u/3254778?s=200&v=4) | A Swift library that simplifies working with SQLite in iOS. |
| **Combine**      | ![Combine Logo](https://developer.apple.com/assets/elements/icons/combine/combine-128x128_2x.png) | For managing reactive data streams and binding the data to the UI. |
| **UIKit**        | ![UIKit Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/UIKit_logo.svg/2560px-Uikit_logo.svg.png) | Used for certain components that require finer control, when not using SwiftUI. |

---

## Installation

To get started with **Splitty**, follow these steps:

### 1. Clone the repository

Clone this repository to your local machine using the following command:

```bash
git clone https://github.com/yourusername/splitty.git
