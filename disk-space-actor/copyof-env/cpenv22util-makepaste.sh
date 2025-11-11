
# cpenv22util  - for general utility tools like diskspace actor and data collection


#@  cpenv## -- means conda env with only pip installs. no conda installs after conda create.
#@                this can be conda pack and unpack on another PC.


#@  Instructions: Paste these commands to terminal a few at a time...



#################################################################
#@  
#@  notes
#@  
####################################   2025-03-27[Mar-Thu]08-41AM 

notes__01 () {
	
echo .

}


#################################################################
#@  
#@  end notes
#@  
####################################   2025-03-27[Mar-Thu]08-41AM 



#################################################################

# settings..

# for convienence, this is repeated a couple times below..


memenv=cpenv22util;
echo ${memenv};


# deactivate other envs before starting..
conda deactivate; conda deactivate; conda deactivate; conda deactivate; deactivate>/dev/null 2>&1;

cd /tmp


#################################################################

# conda create env..

conda deactivate;

conda create --name ${memenv} python=3.12 --yes

conda activate ${memenv}



#################################################################

# install packs necessary..

sudo apt -y install python3-venv
sudo apt -y install libpq-dev


#################################################################

# print info..

conda activate ${memenv}

pth1=/ap/condadev-det-env/condapipenv-dev/${memenv};
pth1x99=/ap/condadev_ml-792/${memenv};


mkdir -p $pth1
cd $pth1

fn1=condaexport-pipfreeze_${memenv}.txt;
file1=$pth1/$fn1;
echo -e " \n pip freeze ======================= $(date +"%Y.%m.%d_%b-%a_%H.%M.%S") =======================\n ">>$file1; pip freeze>>$file1;
echo -e " \n conda export ======================= $(date +"%Y.%m.%d_%b-%a_%H.%M.%S") =======================\n ">>$file1; conda env export >>$file1;
lspenv.sh>>$pth1/lspenv.txt;
date

#################################################################

       
# install first..



pip install psutil  python-dotenv ; date;



#################################################################

# install some..

pip install pyodbc sqlalchemy  pymssql pymysql  colorama; date;


# pip install  backcall bottleneck numexpr  fvcore cloudpickle ; date;


#sudo apt install libpq-dev
pip install psycopg2  wheel; date;

# pip install   jupyterlab tensorboard tensorboard-data-server 

# 2025-05-25 These may already be done...
# pip install   scikit-learn 
# pip install   scipy 
# pip install   opencv-python

# pip install lxml

#################################################################


# add pip only packs..

pip install pycomm3;
pip install pymodbus;
pip install pylogix;
pip install pyueye;
pip install aphyt;
pip install pyserial;
pip install pyusb;
date;

pip install pypylon;

date;





# ------------

# pack it

example_packit_function () {

#memenv=det16env

echo ${memenv};

conda activate ${memenv}
cd /ap/conda-pack.ed
# cd /home/mic-711/conda-pack.ed
echo packing.... this will take a while........
conda pack


}

# ------------


# copy it to another pc


example_copyto_otherpc_function () {

# in terminal in the target pc, copy from ml-696
# just paste the following code that is inside this function.

memenv=cpenv22util

mkdir -p /ap/conda-pack.ed/
echo ${memenv};

echo ${memenv};
rsync -av --info=progress2 --itemize-changes  albe@10.4.64.6:/ap/conda-pack.ed/${memenv}.tar.gz /ap/conda-pack.ed/

ll

# rsync -av --info=progress2 --itemize-changes  albe@10.4.64.6:/media/albe/part2/conda-pack.ed/${memenv}.tar.gz /ap/conda-pack.ed/

# or

scp albe@10.4.64.6:/ap/conda-pack.ed/${memenv}.tar.gz /ap/conda-pack.ed/


}



# ------------


## Example unpacking


# example: qualisense@stppmda6760qsvis1:  /ap/copyof/condadev-ipt51/ipt-dev-51/det14-conda-env.tgz


example_unpacking_function () {

# ref: # https://conda.github.io/conda-pack/#commandline-usage


# just paste the following code that is inside this function.


  memenv=cpenv22util;
  #memenv=det16env

  echo ${memenv};


  cd ~/miniconda3/envs;
  ls -l;
  mkdir -p ${memenv};

  echo 'unpacking with tar... please wait...'

  tar -xzf /ap/conda-pack.ed/${memenv}.tar.gz  -C ${memenv};
  #    or
  # tar -xzf /mnt/data/conda-pack.ed/${memenv}.tar.gz  -C ${memenv};

  conda deactivate;
  source ~/miniconda3/envs/${memenv}/bin/activate;
  # fix prefixes so it will be all good to go..;
  conda-unpack;
  source ~/miniconda3/envs/${memenv}/bin/deactivate;
  conda env list;

  conda activate ${memenv};
  conda env export;

  conda deactivate;


}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~












# S P A C E R  










# S P A C E R  












# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




# more stuff...






notes991 () {

echo .

conda create --clone det16env --name det16e59a

#@  cd /ap/condadev-det-env/ipt-dev-51b/det22env; bash ./ipt58.sh 2>&1 | tee -a log-ipt58-sh$(date +"__%Y.%m.%d_%b-%a_%H.%M.%S").log


}

#################################################################

