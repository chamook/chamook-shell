//@ pragma UseQApplication

import Quickshell

import "modules"

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        delegate: PrimaryBar {
            modelData: item
        }
    }
    Variants {
        model: Quickshell.screens

        delegate: BottomBar {
            modelData: item
        }
    }

    Volume {}
    Launcher {}
}
