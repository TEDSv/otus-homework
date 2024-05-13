## TL;DR
Команды выполнят установку и настройку виртуальной машины на Ubuntu и установку nginx на виртуалку.

Как запустить:

    terraform init
    terraform apply
    ansible-playbook -u ted -i hosts playbook.yml

![msedge_LzhCsC4Mgv](https://github.com/TEDSv/otus-homework/assets/35523575/d78757ce-0965-4efa-8b21-7191656a4234)

Как всё удалить:

     terraform destroy -auto-approve



## Структура файлов:
 - terraform:
	 - main.tf - определяет ресурсы инфраструктуры, которые будут созданы
	 - outputs.tf - определяет выходы, которые можно
   использовать для доступа к информации о инфраструктуре.
	 - providers.tf - определяет поставщиков инфраструктуры
	 - variables.tf - определяет переменные Terraform,
   которые можно использовать в файлах конфигурации.
   
 - ansible: 
	 - hosts - определяет хосты, которые будут управляться с
   помощью Ansible. 
	 - playbook.yml - определяет playbook Ansible, который
   будет использоваться для управления хостами.


## Команды для запуска Terraform
1. `terraform init`:
	 - Инициализирует рабочую директорию Terraform.
	 - Загружает необходимые плагины и поставщиков.
	 - Создает файл состояния Terraform.
2. `terraform validate`:
	 - Проверяет конфигурацию файлов Terraform
![WindowsTerminal_Q3cDvr9WLJ](https://github.com/TEDSv/otus-homework/assets/35523575/d4ae4482-9b87-41ce-ab8e-f570801fe929)

3. `terraform plan`:
	 - Создает план действий Terraform.
	 - Показывает, какие изменения будут внесены в инфраструктуру.
	 - Позволяет вам просмотреть изменения перед их применением.
4. `terraform apply`:
	 - Применяет план действий Terraform.
	 - Создает или обновляет ресурсы инфраструктуры.
	 - Выполняет изменения, описанные в плане.
![WindowsTerminal_T3WJkVqzbk](https://github.com/TEDSv/otus-homework/assets/35523575/ee25b431-1345-419e-bfe4-d951934e7064)

5. `terraform destroy`:
	 - Уничтожает ресурсы инфраструктуры Terraform.
	 - Удаляет ресурсы, созданные с помощью Terraform.
	 - Может использоваться для полного демонтажа инфраструктуры.

## Команды для запуска Ansible
`ansible-inventory --list -y -i hosts` - выводит список инвентори
 `ansible -m ping -i hosts` - запускает пинг по списку hosts
 `ansible-playbook -u ted -i hosts playbook.yml` запускает выполнение плейбука
![WindowsTerminal_iLNJYbAshA](https://github.com/TEDSv/otus-homework/assets/35523575/302e178b-482e-45ff-ab58-356536a5210e)



