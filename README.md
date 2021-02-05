# GCloud function RemoveBg

This gcloud function provide an http endpoint to remove a background from an image.  
Background image is removed with awesome [rembg](https://github.com/danielgatis/rembg) project.  
rembg use pytroch and u2net to remove the background.  
u2net is already in the project to avoid dowloading it before first run.  


## Deploy
`$ make deploy`

## Run local
`$ make run-local`

## Request background removing

`curl -o final_img.jpg "https://REGION-PROJECT_ID.cloudfunctions.net/removeBg?image_source_url={image_to_remove_bg}"`
