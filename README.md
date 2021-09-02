# GCR Pruner

Prunes Google Container Registry images by

- a) deleting older than DELETE_OLDER_THAN=2020-01-01
- b) keeping only last KEEP_DIGESTS tags

run locally:

    PROJECTS="project1 project2" DELETE_OLDER_THAN=2020-01-01 KEEP_DIGESTS=2 GCLOUD_CONCURRENCY=16 app/pruner.sh

or deploy to google cloud run with:

    PROJECTS="project1 project2" DELETE_OLDER_THAN=2020-01-01 KEEP_DIGESTS=2 GCLOUD_CONCURRENCY=16 bin/deploy myproject eu.gcr.io/myproject/gcr-pruner europe-north1

and then

    $ curl https://gcr-pruner-sztaxlbmya-lz.a.run.app

and schedule with Google Cloud Scheduled Tasks!


Similar to https://github.com/sethvargo/gcr-cleaner and https://gist.github.com/ahmetb/7ce6d741bd5baa194a3fac6b1fec8bb7 but automatically scans & prunes everything!