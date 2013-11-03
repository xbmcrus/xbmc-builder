xbmc-builder
============

Build scripts for XBMC and related packages.

forked from AndreyPavlenko/xbmc-builder

#  Создаем директории

mkdir $HOME/ppa

mkdir $HOME/ppa/sources

cd $HOME/ppa/sources

git clone https://github.com/xbmc/xbmc.git

exit

#  Клонируем билд скрипты

mkdir -p $HOME/ppa/builders/xbmc-builder

git clone https://github.com/AndreyPavlenko/xbmc-builder.git $HOME/ppa/builders/xbmc-builder

# Cоздаём в домашней директории конфигурационный файл 

sudo nano  ~/.build.config

# В этом файле нужно прописать настройки 

GPGKEY='ключ в РРА' 

DEBEMAIL='имя <e-mail>' указываем данные в РРА 

например такие данные РРА: aap <andrey.a.pavlenko@gmail.com>

PPA_URL='ссылка на рра и ветка куда отправлять собранные source.changes'

например 'https://launchpad.net/~aap/+archive/xbmc-fernetmenta'

TARGET_PLATFORMS='precise:amd64 quantal:amd64 raring:amd64 saucy:amd64'

указываем платформы убунт для сборки (i386 по умолчанию)

: ${MAINTAINER:="$DEBEMAIL"}

: ${BUILDPACKAGE_ARGS:="-k$GPGKEY"}

: ${SOURCES_DIR:="$HOME/ppa/sources"}

: ${PPA_BUILDER:="$HOME/ppa/ppa-builder"}

: ${BASETGZ_DIR:='/var/cache/pbuilder/base'}

: ${APT_CACHE_DIR:='/var/cache/pbuilder/aptcache'}

: ${BUILD_DIR:="/tmp/build/$$"}

: ${DEB_MIRROR:='http://ru.archive.ubuntu.com/ubuntu'}

устанавливаем утилиту dput,

создаём dput.cf в домашней директории файл для отправки пакетов в РРА

sudo nano  ~/dput.cf

заполняем :

[frodo] 

fqdn = ppa.launchpad.net 

method = ftp 

incoming = ~bigbax/frodo/ubuntu/ 

login = anonymous 

allow_unsigned_uploads = 0
  
9. Входим в директорию с .git

cd $HOME/ppa/builders/xbmc-builder/xbmc

10. Собираем:

TARGET_PLATFORMS='precise:amd64 quantal:amd64 raring:amd64 saucy:amd64' ./build.sh create

11. Отправляем в РРА 6

PPA=рра_указанный_в_build.config ./build.sh upload

12. ## Если имеется, то делаем предподготовку в своём github:

git clone https://github.com/bigbelec/xbmc.git

13. cd xbmc

14. git init

15. Переключаемся на нужную ветку гита :

git checkout frodo

16. На запрос :

*** Please tell me who you are.

вводим поочерёдно :

git config --global user.email "логин в github"

git config --global user.name "password" пароль пользователя в самой системе убунту

17. делаем изменения(патчи) в локальном гите

18. индексируем:

git add .

19. делаем коммит:

git commit -a -m 'pvr: fix channel switch for addons using other stream'

20. отправляем измнения в гит в инете:

git push -u https://github.com/bigbelec/xbmc.git

Username for 'https://github.com': bigbelec2014@yandex.ru

Password for 'https://bigbelec2014@yandex.ru@github.com':  пароль в github

21. Работа с своим github :

cd ~/ppa/sources

git clone -b frodo https://github.com/bigbelec/xbmc.git

cd xbmc

git status

если в ответ frodo, то всё сделано правильно,   и

exit

21. У себя в github также делаем по дефолту например ветвь frodo

22. Меняем в конфигурации ветку для сборки:

sudo nano ~/ppa/builders/xbmc-builder/xbmc/build.sh 

: ${PKG_NAME:='xbmc'}

: ${PKG_EPOCH:='2'}

: ${SRC_URL:='https://github.com/bigbelec/xbmc.git'}

: ${REV:='origin/frodo'}

23. И наконец создаем source.changes для отправки в РРА :

cd ~/ppa/builders/xbmc-builder/xbmc

TARGET_PLATFORMS='precise:amd64 quantal:amd64 raring:amd64 saucy:amd64' ./build.sh create


24. Входим в каталог с сырцами: 

cd ~/ppa/builders/xbmc-builder/xbmc/distribs/26.10.13/src

25. И если нужно , то отправляем в РРА вручную :

dput ppa:bigbax/frodo xbmc_12.2-20398~cf3a9a5-ppa1~precise_source.changes

26. Создаем патч.

git diff > ~/ppa/builders/xbmc-builder/xbmc/debian/patches/strings.patch

27. Прописываем этот патч в debian/patches/series

sudo nano ~/ppa/builders/xbmc-builder/xbmc/debian/patches/series

впишем strings.patch

28. Делаем и отправляем в РРА аддоны :

cd ~/ppa/sources

git clone https://github.com/pipelka/xbmc-addon-xvdr.git

exit

29. Собираем : 

cd ~/ppa/builders/xbmc-builder/xbmc-addon-xvdr

TARGET_PLATFORMS='precise:amd64 quantal:amd64 raring:amd64 saucy:amd64' ./build.sh create

exit

cd ~/ppa/builders/xbmc-builder/xbmc-addon-xvdr/distribs/26.10.13/src

30: отправляем в своё РРА :

dput ppa:bigbax/frodo xbmc-addon-xvdr_0.9.8-361~acd4e14-ppa1~precise_source.changes
