# GCloud run RemoveBg

This gcloud run provide an http endpoint to remove a background from an image.  
Background image is removed with awesome [rembg](https://github.com/danielgatis/rembg) project.  
rembg use pytroch and u2net to remove the background.  
u2net is already in the project to avoid dowloading it before first run.  

## Requirements
- Docker
- [buildpacks](https://buildpacks.io/) 
- gcloud cli configured (gcloud init, gcloud auth login)
- a gcloud project id with billing enabled

In order to publish your container, you need to publish custom run image.  
This image is used to install dev dependencies used by rembg on functions container.
```
$ projectId={gcloud_project_id} make publish-run-image
```

## Publish & Deploy

### Publish built pack
To build and publish to container repository, we use buildpacks.
```
$ projectId={gcloud_project_id} make publish
```

### Deploy
After your container has been published, you can deploy your gcloud run container
```
$ projectId={gcloud_project_id} make deploy
```
If deploy is success, Service URl is returned (E.g: https://removebg-{someID}-ew.a.run.app). 

#### Test your deployment
`curl -o final_img.jpg "${SERVICE_URL}?image_source_url={image_to_remove_bg}"`


## Development & Testing

### Run in a local docker container
```
$ make run-local-docker
```

### Run in localhost
Test removeBg function in local with venv and functions_framework.  

Set Virtual environment: `python3 -m venv env/`  
Activate venv: `source env/bin/activate`

Run local function:
```
$ make run-local
```

