
# how to create the python venv


python -m venv venv001
chmod +x venv001/bin/activate
venv001/bin/activate
::# windows..
.\venv001\Scripts\activate

::python -m pip install --upgrade pip


:: for windows..
(
  @echo.pyyaml
 #@echo.numpy
 #@echo.scikit-image
 #@echo.matplotlib
 # this won't work. Just edit the file.. @echo.'django>=2,<3'
) >requirements.txt

pip install -r requirements.txt

