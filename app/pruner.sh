#!/usr/bin/env bash

set -euo pipefail

_echoerr() {
  1>&2 echo $@
}

_term() {
  _echoerr "bye"
  exit 0
}

trap _term TERM INT

_cleanup() {
  images=$(gcloud container images list --repository "$1" --format='value(name)')
  for image in $images; do
    _cleanup $image
  done

  tags=$(2>/dev/null gcloud container images list-tags --quiet --project "$PROJECT" "$1" --filter="timestamp.datetime >= ${DELETE_OLDER_THAN}")

  if [ "$tags" = "" ]; then
    echo "DELETE $1"
    sed_trim=""
  else
    echo "PRUNE  $1"
    sed_trim="1,${KEEP_DIGESTS}d"
  fi

  digests=$(gcloud container images list-tags \
    --quiet --project "$PROJECT" "$1" \
    --sort-by="~timestamp" --format='get(digest)' \
    | sed "$sed_trim")

  if [ $(echo "$digests" | wc -l) -gt ${KEEP_DIGESTS} ]; then
    for digest in $digests; do
      echo "'${1}@${digest}'"
    done | xargs -n 1 -P "$GCLOUD_CONCURRENCY" -- gcloud container images delete -q --force-delete-tags
    echo ""
  fi
}

for PROJECT in $PROJECTS; do
  for registry in gcr.io asia.gcr.io eu.gcr.io us.gcr.io; do
    images=$(gcloud container images list --repository "$registry/$PROJECT" --format='value(name)')

    for image in $images; do
      _cleanup "$image"
    done
  done
done

echo
echo "DONE"