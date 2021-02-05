from flask import make_response
from rembg.bg import remove
import numpy as np
import io
import requests
from os import environ, path

# Set env var for u2net path
root = path.dirname(path.abspath(__file__))
environ['U2NET_PATH'] = path.join(root, 'u2net', 'u2net.pth')


def removeBg(request):
    """HTTP Cloud Function used to remove image background using rembg (https://github.com/danielgatis/rembg).
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or image bytes using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    """
    request_args = request.args
    response = ''
    # check if parameters exists
    if request_args and 'image_url_source' in request_args:
        try:
            # Download taget url
            r = requests.get(request_args['image_url_source'])
            # Convert image bytes to numpy array
            f = np.frombuffer(r.content, dtype=np.uint8)
            # Call rembg remove method
            result = remove(f)
            # Transform rembg result to bytesIO
            img_bytesIO = io.BytesIO(result)
            # make response with images bytes as string
            response = make_response(img_bytesIO.getvalue())
            # Set headers
            response.headers.set('Content-Type', 'image/png')
        except Exception as e:
            response = str(e)
    else:
        response = 'Query parameter "image_url_source" is missing'

    return response
