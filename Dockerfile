FROM johanngb/rep-int:latest

### Prepare for installation
ENV DEBIAN_FRONTEND noninteractive
RUN apt update
RUN apt install -y gdebi-core 
WORKDIR /home/rep/

RUN /usr/bin/python3 -m pip install --upgrade pip

### Packages
RUN pip install sklearn nltk umap umap-learn hdbscan chart_studio

WORKDIR /home/rep/
COPY Code/Downloading Tweets to a CSV.ipynb Code/Downloading Tweets to a CSV.ipynb
COPY Code/Random Forest Labeling.ipynb Code/Random Forest Labeling.ipynb
COPY Code/data preprocessing modified.R Code/data preprocessing modified.R
COPY Code/monocle3.R Code/monocle3.R
COPY Code/vader_r_final.Rmd Code/vader_r_final.Rmd
COPY Data/*