# ubuntu 16.04 LTS

- [Quickstart for Debian and Ubuntu](https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu)

```bash
$ export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
$ echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
$ curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
$ sudo apt-get update && sudo apt-get install google-cloud-sdk
```

## エラー

```bash
Setting up google-cloud-sdk (175.0.0-0) ...
Generating the gcloud CLI and caching in [/usr/lib/google-cloud-sdk/.install/cli/gcloud.py]...failed.                                                                                                      
ERROR: gcloud failed to load (gcloud.beta.ml.operations.cancel): Problem loading gcloud.beta.ml.operations.cancel: cannot import name operations.

This usually indicates corruption in your gcloud installation or problems with your Python interpreter.

Please verify that the following is the path to a working Python 2.7 executable:
    /usr/bin/python2
If it is not, please set the CLOUDSDK_PYTHON environment variable to point to a working Python 2.7 executable.

If you are still experiencing problems, please run the following command to reinstall:
    $ gcloud components reinstall

If that command fails, please reinstall the Cloud SDK using the instructions here:
    https://cloud.google.com/sdk/
dpkg: error processing package google-cloud-sdk (--configure):
 subprocess installed post-installation script returned error exit status 1
Errors were encountered while processing:
 google-cloud-sdk
E: Sub-process /usr/bin/dpkg returned an error code (1)
```
