# OGame for iOS

OGame is a browser-based, money-management and space-war themed massively multiplayer online browser game with over two million accounts.

## Description

This is my pet-project which I'm doing at my free time. I'm still learning iOS development, so this project may have a lot of issues and bugs. Hope for your understanding.
- Project is written with **UIKit**.
- The architecture is **MVC**.
- Interface layout with **code** and some **storyboards**.
- Networking with **Alamofire**.
- Parsing **HTML** with **SwiftSoup** framework.

## Screenshots
### Authorization and menu
![screenshot-1](https://i.imgur.com/HLMXwv4.png)
### Construct buildings, research technologies
![screenshot-2](https://i.imgur.com/5OUxZYb.png)
### Sending fleet, movement and galaxy
![screenshot-3](https://i.imgur.com/AzvEGqP.png)

## To-Do
- Move project to MVP architecture ([in progress](https://github.com/SubvertDev/OGame-iOS-Unofficial/tree/switch-to-mvp))
- Add construction queue
- Check for maximum builds
- Show remaining build time online
- Discarding unnecessary network requests
- Messaging feature
- Update UI with game assets

## Known Issues
- Planets are not added to menu after colonization
- Scuffed defense images
- IRN is not supported
- Wrong build times on non-main planet
- Send fleet view has no full cargo/distance info
- Admin planets considered yours on galaxy view

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Initially based on [@alaingilbert](https://github.com/alaingilbert/) [pyogame](https://github.com/alaingilbert/pyogame/) repository.
