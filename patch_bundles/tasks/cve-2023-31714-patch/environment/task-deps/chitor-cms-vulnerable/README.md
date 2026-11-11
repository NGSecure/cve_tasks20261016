
# Introduction

> This project is a school managment system. It is implemented in Govt Higher Secondary School Chitor Swat KPK. Some of its features are ...
![index page](https://user-images.githubusercontent.com/13853450/227044754-546a955e-f01b-4534-876e-2f1582e259f0.png)

> Student Add/Edit/Delete.
![image](https://user-images.githubusercontent.com/13853450/227787269-690c171b-1183-43a8-8b84-62cc0ff191db.png)
> Exam marks Add/Edit/Print DMC
![DMC](https://user-images.githubusercontent.com/13853450/227045364-7c662486-9ca3-4fad-ba38-f9250095e6e9.png)
> Exam Roll No Slip, Award List generation.
![image](https://user-images.githubusercontent.com/13853450/227787431-7d8e168e-c88b-42fd-b48b-c8d9498f2cd9.png)
> Login system/ Locking mechanism.
> Time Table of classes and vacant can be generated.
> Class and Subject wise exam reports can be generated.
![Report Class wise](https://user-images.githubusercontent.com/13853450/227046321-f1409e9c-a519-49f0-8a58-ff2b600035e4.png)

## Built With

- HTML5
- CSS3
- Javascript
- Bootstrap 5
- MySQL
- PHP 8.2
- Ajax

## Live Demo

- Use username `guest` and password `guest` for guest acccount.
- Use username `admin` and password `admin` for admin account.

> -  [Visit Live Demo](https://chitor.000webhostapp.com/)

- Free free to suggest improvements at waqaskanju@gmail.com

## Getting Started

To get a local copy up and running follow these sample steps.

- A text editor(preferably Visual Studio Code). For making changes in code. [Download Visual Studion Code](https://code.visualstudio.com/)
- A Server to host file. We need Php, Apache and mysql Stack (Preferably Wamp Server)    [Download Wamp Server](https://www.wampserver.com/en/#download-wrapper)
- For Group Development. A version contoling software (Preferably Git)  [Download Git](https://git-scm.com/downloads)

## Installation
- Put the 'Chitor-CMS' folder inside your 'WWW' Directory in WampServer Installtion folder.
- Or in the htdocs folder in case of XAMPP Software.
- Open mysql and import the database. the database file is available inside Database Folder.
- To install the file listed in Composer.json file. type inside cmd

```bash
$ php composer.phar update
```

- Or manually the following items should be installed for better code quality.
- Code Sniffer (PHP Linter) inside cmd when composer is installed.Type the following to install.

```bash
$ composer global require "squizlabs/php_codesniffer=*"
```

### Usage
Free to use for your work

#### Clone this repository

```bash
$ git clone https://github.com/waqaskanju/Chitor-LMS.git
$ cd Chitor-LMS
```

### To fix linter errors

```bash
$ phpcbf [filename]
```

### To find linter error

```bash
$ phpcs [filename]
```

For Real time error linter error show install "shevaua.phpcs" extension in VS Code.

#### To Ignore a folder in checking linter errors. In this case test folder.

```bash
$ phpcs --ignore=*/test
```
## Author

👤 **Waqas Ahmad**

- GitHub: [@waqaskanju](https://github.com/waqaskanju)
- Twitter: [@waqaskanju](https://twitter.com/waqaskanju)
- LinkedIn: [@waqaskanju](https://www.linkedin.com/in/waqaskanju)


## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](../../issues/).

## Show your support

Give a ⭐️ if you like this project!


## 📝 License

This project is [MIT](./MIT.md) licensed.
