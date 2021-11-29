
# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."

## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

- Полная(аппаратная) виртуализация - это виртуализация, которая работает на аппаратном уровне без необходимости установки хостовой операционной системы
т.к. сама является такой операционной системой
Не требуется модификация ядра гостевой операционнной системы

- Паравиртуализация - это виртуализация, которая для своей работы требует наличие операционной системы на хосте для доступа гипервизора к аппаратным ресурсам хоста
Также требуется модификация ядра гостевой операционной системы для разделения доступа к аппаратным средствам физического сервера

- Виртуализации на основе операционной системы(программная виртуализация)- это виртуализацию на уровне ядра операционной системы, в которой все виртуальные машины используют общее модифицированное ядро хоста, что позволяет запускать изолированные и безопасные окружения(контейнеры) на одном хосте с таким же ядром,как и ядро хостовой системы

## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:
- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу.
- Различные web-приложения.
- Windows системы для использования бухгалтерским отделом.
- Системы, выполняющие высокопроизводительные расчеты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

- Высоконагруженная база данных, чувствительная к отказу - физические сервера
  - Максимальная производителность по процессору/дисковым операциями ввода/вывода,что является достаточно важным для работы высоконагруженной базы данных
  - Отсутствие накладных расходов, связанных с использованием виртуализации

- Различные web-приложения - виртуализация уровня ОС
  - Производительность близкая к хостовой
  - Возможность удобно создавать много легких/быстрых виртуалок с различными web-приложениями, различными версиями программного обеспечения в них,создавать снепшоты/бекапы вируталок, восстанавливаться с них

- Windows системы для использования бухгалтерским отделом - паравитуализация
  - эффективно использовать аппаратные ресурсы за счет паравиртуализации

- Системы, выполняющие высокопроизводительные расчеты на GPU - физическая машина
  - нет необходимости использования виртуализации т.к. гипервизоры не умеют виртуализировать графические ядра т.е просто происходит проброс ядер графического процессора
  с хостовой системы внутрь гостевой системы

## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.

    VMWare vSphere
      - наиболее сбалансированным и универсальным продуктом для организаций с высокими требованиями к их виртуальной инфраструктуре.

2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.

    KVM
      - универсальное решение, поддерживающее запуска как Linux так и Windows виртуальных машин
      - бесплатность
      - хорошая производительность

3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.

    Xen в режиме паравиртуализации(PV) или KVM
      - бесплатность

4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

    LXC
      - максимальная производительность т.к. используется виртуализация на уровне операционной системы(программная виртуализация)
      - бесплатность
      - готовые базовые образы linux-based операционных систем, которые используются при создании виртуальной машины(точнее называть контейнеров)

## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

Недостатки гетерогенной среды виртуализации:
 - сложность миграции данных между разными виртуальными средами или из физической среды в виртуальную
 - необходима соответствующая экспертиза команды инженеров, чтобы качественно поддерживать различные гипервизоры, что влечет за собой высокую финансовую стоимость такой поддержки
 - сложность обеспечения простоты в управлении, совместимости различных систем и масштабируемости инфраструктуры.

Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

Старался использовать бы один универсальный виртуализатор/гипервизор, чтобы он удовлетворял всем требованиям, которые выдвигаются к гипервизору, воизбежания указанных выше недостатков использования гетерогенных сред виртуализации
Это позволит снизить вероятность несовместимости технологий и упростить управление инфраструктурой для обеспечения совместимости и масштабируемости ИТ-инфраструктуры в рамках всей виртуальной среды

С другой стороны,если, например, есть Linux и Windows машины и при этом лицензии одного и того же виртуализатора(например, Hyper-V или VmWare) стоят очень дорого, то есть смысл просчитать экономическую целесообразность покупать лицензии только для Windows-машин, а для Linux использовать бесплатную виртуализацию на базе KVM