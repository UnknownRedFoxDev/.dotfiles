import json
import sys
from time import sleep
from functools import partial
from PyQt6 import uic, QtGui
from PyQt6.QtGui import QIcon
from PyQt6.QtCore import QTimer
from PyQt6.QtWidgets import QApplication, QMainWindow

from scripts.menus import cardMenu
from scripts.players import Deck, Client
from scripts.utils import warningBox

DEFAULT_CARD: tuple = (-1, -1)


class Game(QMainWindow):
    def __init__(self):
        super().__init__()
        ip = input("INPUT SERVER IP: ")
        self.client = Client(ip)
        self.client.start()

        self.defaultCase = {DEFAULT_CARD, ()}
        self.deckGame = Deck()

        # Starting variables
        self.deckWindow = None

        self.cardMenu = None
        sleep(0.5)

        # Load the UI
        if self.client.player == 1:
            uic.loadUi("./data/UIs/cardGame-Player1.ui", self)
            self.setWindowTitle("War Game - Player 1")
        else:
            uic.loadUi("./data/UIs/cardGame-Player2.ui", self)
            self.setWindowTitle("War Game - Player 2")

        # Fixes the window
        self.setWindowIcon(QIcon("./data/images/QTImages/carte.png"))
        self.setFixedSize(self.size())
        self.show()  # Then displays it.

        # Creating a repeating clock that calls the processData function every 100ms.
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.updateComponents)
        self.timer.start(100)

        # Connect the buttons.
        self.cardVault_QButton.clicked.connect(self.showDeck)
        if self.client.player == 1:
            self.send_QButton.clicked.connect(partial(self.sendMessage, 1))
        else:
            self.send_QButton.clicked.connect(partial(self.sendMessage, 2))

        # Initialize the variables.
        self.currentRound = 1
        self.gamemode = self.client.gamemode
        self.gm_QLabel.setText(f"First to get : {self.gamemode} points")

        # Displays the cards on the screen.
        self.changeCards(
            self.currentCardDisplayP1_QLabel,
            self.currentCardNameP1_QLabel,
            self.client.P1.currentCard,
        )
        self.changeCards(
            self.currentCardDisplayP2_QLabel,
            self.currentCardNameP2_QLabel,
            self.client.P2.currentCard,
        )

    def showDeck(self):
        """
        Shows your deck with another window.
        """
        if self.deckWindow:
            self.deckWindow.close()

        if self.client.player == 1:
            self.deckWindow = cardMenu(self, self.client.P1)
        elif self.client.player == 2:
            self.deckWindow = cardMenu(self, self.client.P2)
        if self.deckWindow:
            self.deckWindow.show()

    def updateComponents(self):
        if self.client.resultReceived:
            self.changeCards(
                self.currentCardDisplayP1_QLabel,
                self.currentCardNameP1_QLabel,
                self.client.P1.currentCard,
            )
            self.changeCards(
                self.currentCardDisplayP2_QLabel,
                self.currentCardNameP2_QLabel,
                self.client.P2.currentCard,
            )
            self.send_QButton.setEnabled(True)
            self.cardVault_QButton.setEnabled(True)
            self.client.P1.currentCard = DEFAULT_CARD
            self.client.P2.currentCard = DEFAULT_CARD
            self.client.resultReceived = False
            self.gameLoop()

    def sendMessage(self, player=None):
        """
        Sends the message to the other player.
        """
        ready = 0
        if player == 1:
            if (
                self.client.P1.currentCard not in self.defaultCase
                ):  # Make sure that the player has selected a card.
                self.client.P1.ready = True
                self.send_QButton.setEnabled(False)
                self.cardVault_QButton.setEnabled(False)
                ready = 1
            else:
                # If you forgot to select a card, it will display a warning.
                warningBox(
                    "Careful!",
                    "Please select a card.",
                    "./data/images/QTImages/warning.png",
                )
                self.client.P1.ready = False
                ready = 0

        elif player == 2:
            # Same stuff here.
            if self.client.P2.currentCard not in self.defaultCase:
                self.client.P2.ready = True
                self.send_QButton.setEnabled(False)
                self.cardVault_QButton.setEnabled(False)
                ready = 1
            else:
                warningBox(
                    "Careful!",
                    "Please select a card.",
                    "./data/images/QTImages/warning.png",
                )
                self.client.P2.ready = False
                ready = 0

        if ready == 1:
            message = json.dumps(
                {
                    "P1": (self.client.P1.ready, self.client.P1.currentCard),
                    "P2": (self.client.P2.ready, self.client.P2.currentCard),
                }
            )
            self.client.send(message)
            self.updateComponents()

    def changeCards(self, display, name, currentCard: tuple):
        """
        Changes the cards displayed in the game.
        With the text that shows what card is being played.
        :param display: QLabel from the window
        :param name: QLabel from the window
        :param currentCard: The player's current card (e.g.: self.client.P1.currentCard)
        """
        if currentCard in self.defaultCase:
            display.setPixmap(QtGui.QPixmap("./data/images/cards/54.png"))
            name.setText("None")
        else:
            display.setPixmap(
                QtGui.QPixmap(
                    "./data/images/cards/{self.deckGame.images[currentCard]}.png"
                )
            )
            name.setText(self.deckGame.cardName(currentCard))

    def gameLoop(self):
        self.currentRound += 1
        if (self.client.P1.victoryCount < self.gamemode and self.client.P2.victoryCount < self.gamemode):
            roundWinner = self.client.roundWinner
            self.currentWinner_QLabel.setText(f"Round N°{self.currentRound} | WINNER : {roundWinner}")
            self.victoryCountP1_QLabel.setText(f"Score : {self.client.P1.victoryCount}")
            self.victoryCountP2_QLabel.setText(f"Score : {self.client.P2.victoryCount}")
        else:
            self.send_QButton.hide()
            self.cardVault_QButton.hide()

            if self.client.P1.victoryCount >= self.gamemode:
                self.currentWinner_QLabel.setText(f"Round N°{self.currentRound} | GAME WINNER: Player 1")
            else:
                self.currentWinner_QLabel.setText(f"Round N°{self.currentRound} | GAME WINNER : Player 2")


app = QApplication(sys.argv)
window = Game()
window.show()

app.exec()
