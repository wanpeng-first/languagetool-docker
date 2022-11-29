FROM alpine as ftbuild

RUN apk update && apk add \
        build-base \
        wget \
        git \
        unzip \
        && rm -rf /var/cache/apk/*

RUN git clone --depth 1 --branch v0.9.2 https://github.com/facebookresearch/fastText.git /tmp/fastText && \
  rm -rf /tmp/fastText/.git* && \
  mv /tmp/fastText/* / && \
  cd / && \
  make

RUN wget https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin

# RUN wget https://languagetool.org/download/ngram-lang-detect/model_ml50_new.zip

#v5.9
FROM erikvl87/languagetool

COPY --chown=languagetool --from=ftbuild /fasttext .
# COPY --chown=languagetool --from=ftbuild /model_ml50_new.zip .
COPY --chown=languagetool --from=ftbuild /lid.176.bin .

ENV langtool_fasttextBinary=/LanguageTool/fasttext
# ENV langtool_ngramLangIdentData=/LanguageTool/model_ml50_new.zip
ENV langtool_fasttextModel=/LanguageTool/lid.176.bin
