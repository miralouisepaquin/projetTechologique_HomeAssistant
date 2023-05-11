# projetTechologique_SchoolAssistant
application en swift 5 avec Xcode 14 qui va simuler un système de gestion d'alarme de maison.

## Table of Contents
1. [Last Update](#last-update)
2. [General Info](#general-info)
3. [Technologies](#technologies)
4. [Installation](#installation)

### Last Updates
***
V4.1 Ajout de la gestion des langues grâce à un menu déroulant dans la page des settings.
### General Info
***
Le système utilise la technologie MQTT afin de recevoir et transmettre les informations provenant de l'application et des senseurs. L'application utilise un API Rest sur un serveur distant avec une base de donnée en MongoDB. Les senseurs quand à eux utilisent du language Zigbee pour communiquer avec le Broker.
## Technologies
***
Voici la liste des technologies utilisées dans le projet:
* [CocoaPods](https://cocoapods.org/) 
* [Xcode](https://developer.apple.com/xcode/): Version 14
* [Mosquitto](https://mosquitto.org/): Version 5.0
* [API Rest](https://www.bezkoder.com/node-express-mongodb-crud-rest-api/): Version 4.18.1
* [CocoaMQTT](https://cocoapods.org/)
## Installation
***
Afin de pouvoir utiliser l'application et la lancé, il faudra d'abord installer CocoaPods sur votre MAC. Puis, installer la librairie CocoaMQTT.
```
$ sudo gem install cocoapods
```
Dans le dossier du projet, il faudra trouver le fichier pods et le modifier comme suit:
```
  platform :ios, '12.0'
  use_frameworks!

  target 'MyApp' do
    pod 'CocoaMQTT'
  end
```
Puis il sera possible d'installer les dépendence en éxécutant le fichier:
```
$ pod install
```
