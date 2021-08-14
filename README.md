### Установите средство виртуализации [Oracle VirtualBox](https://www.virtualbox.org/).

```bash
$ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
$ sudo apt-get update
$ sudo apt-get install virtualbox-6.1
$ dpkg -l | grep virtualbox
ii  virtualbox-6.1 6.1.26-145957~Ubuntu~bionic  amd64 Oracle VM VirtualBox
```

### Установите средство автоматизации [Hashicorp Vagrant](https://www.vagrantup.com/).

```bash
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com (lsb_release -cs) main"
$ sudo apt-get update
$ sudo apt-get install vagrant
$ vagrant --version
Vagrant 2.2.18
```
### Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?

```bash
CPU: 2
RAM: 1024MB
HDD: 64GB (vmdk-формат)
```
### Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html). Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

```bash
$ cat Vagrantfile
Vagrant.configure("2") do |config|
   config.vm.box = "bento/ubuntu-20.04"
   config.vm.provider "virtualbox" do |v|
     v.memory = 2048
     v.cpus = 3
   end
end
```

### Какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?
`HISTFILESIZE`

Строка 734
```bash
$ man bash | grep -A2 -n HISTFILESIZE
734:       HISTFILESIZE
735-              The maximum number of lines contained in the history file.  When this variable is assigned a value, the history file is  trun‐
736-              cated,  if  necessary,  to contain no more than that number of lines by removing the oldest entries.  The history file is also
```

### Что делает директива `ignoreboth` в bash?

`ignoreboth` - это значение переменной оболочки `HISTCONTROL`

Переменная `HISTCONTROL` определяет как команды сохраняются в списке истории

Значение `ignoreboth` является сокращением для `ignorespace` и `ignoredups`.

Значение `ignoredups` приводит к тому, что дублирующиеся строки не сохраняются в журнал/список истории команд

Значение `ignorespace` приводит к тому, что строки, начинающиеся с символа пробела, не сохраняются в журнал/список истории команд

т.е. при присваивании переменной `HISTCONTROL` значения `ignoreboth` в журнал/список истории команд не будут сохраняться
дублирующиеся строки и строки, начинающиеся с символа пробела


### В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?
- опредление переменных массива. Строка 898. Пример: `${name[subscript]}`
- расскрытие скобок. Строка 946. Пример: `a{d,c,b}e`
- подстановка переменных/парамертров. Строка 1005. Пример: `${переменная}`
- функции. Строка 2618. Пример:
```bash
myfunction () { тело функции } { виды переадресации }
```
Либо
```bash
function myfunction [()] { тело функции } { виды переадресации }
```


### Основываясь на предыдущем вопросе, как создать однократным вызовом touch 100000 файлов? А получилось ли создать 300000? Если нет, то почему?

```bash
touch {1..100000}.txt`
```
```bash
$ ls -l [0-9]*.txt | wc -l
100000
```

```bash
$ touch {1..300000}.txt
bash: /usr/bin/touch: Argument list too long
```

Дефолтный размер аргументов командной составляет 8192 KB
```bash
$ ulimit -s
```
```
8192
```

При необходимости его можно увеличить, например, до 65535 KB
```bash
$ ulimit -s 65535
```
```bas
$ ulimit -s
```
```bash
65535
```


После чего появляется возможность создать 300000 файлов
```bash
$ touch {1..300000}.txt
```
```bash
$ ls -l [0-9]*.txt | wc -l
300000
```


### В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`

`[[ ]]` - условные выражения

`[[ -d /tmp ]]` - проверка существует ли каталог /tmp


### Чем отличается планирование команд с помощью `batch` и `at`?

`at` – это утилита командной строки, которая позволяет планировать выполнение команд в определенное время. Задания, созданные с помощью at, выполняются только один раз.

`batch` или его псевдоним `at -b`, планирует задания и выполняет их в очереди пакетов, когда позволяет уровень загрузки системы.
По умолчанию задания выполняются, когда средняя загрузка системы ниже 1,5.
Значение загрузки может быть указано при вызове демона `atd`.
Если средняя загрузка системы выше указанной, задания будут ждать в очереди.

т.е. `at` выполняется в указанное время незаависимо от нагрузки системы перед стартом выполнения задачи, a `batch`
выполняется в указанное время, если нагрузка в системе не превышает пороговое значение, установленное в настройках демона `atd`