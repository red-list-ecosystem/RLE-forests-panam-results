
export MIHOST=$(hostname -s)

export PROJECTNAME=RLE-forests-panam-results
export PROJECTFOLDER=proyectos/IUCN
export SCRIPTDIR=${HOME}/${PROJECTFOLDER}/${PROJECTNAME}

case $MIHOST in
terra)
  export GISDATA=/opt/gisdata
  export GISDB=/opt/gisdb/ecosphere
  export WORKDIR=$HOME/tmp/$PROJECTNAME
  source $HOME/.profile
  export SRCDIR=$HOME/Cloudstor/UNSW/data/
  ;;
roraima)
  export GISDATA=$HOME/gisdata
  export GISDB=$HOME/gisdb/ecosphere
  export WORKDIR=$HOME/tmp/$PROJECTNAME
  export SRCDIR=$HOME/Cloudstor/UNSW/data/
  ;;
*)
  if [ -e /srv/scratch/cesdata ]
  then
    export SHAREDSCRATCH=/srv/scratch/cesdata
    export GISDATA=$SHAREDSCRATCH/gisdata
    export GISDB=$SHAREDSCRATCH/gisdb
    export OUTDIR=$SHAREDSCRATCH/output/$PROJECT
    source $HOME/.secrets
  else
    echo "I DON'T KNOW WHERE I AM, please customize project-env.sh file"
  fi
  ;;
esac

##IUCN_RLTS_DataRequest/data_request_150218
##export SRCDIR=/home/${zID}/data/

mkdir -p $WORKDIR
grep -A4 IUCNdb $HOME/.database.ini | tail -n +2 > tmpfile
while IFS="=" read -r key value; do
  case "$key" in
    "host") export DBHOST="$value" ;;
    "port") export DBPORT="$value" ;;
    "database") export DBNAME="$value" ;;
    "user") export DBUSER="$value" ;;
  esac
done < tmpfile
rm tmpfile
