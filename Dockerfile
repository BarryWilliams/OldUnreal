FROM ubuntu:24.04

# RUN apk update && \
#     apk add rsync && \
#     rm -rf /var/cache/apk/*

RUN apt update && \
    apt install rsync net-tools -y

ARG old_unreal_source=https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v469e/OldUnreal-UTPatch469e-Linux-amd64.tar.bz2

ADD --unpack=true ${old_unreal_source} /tmp/OldUnreal_Source

ARG \
    folder_ut_compiled=/ut_compiled \
    folder_2_middle_oldunreal=/2-middle_oldunreal

ENV \
    FOLDER_UT_COMPILED="${folder_ut_compiled}" \
    FOLDER_1_UPPER_USER_FILES=/1-upper_user-files \
    FOLDER_2_MIDDLE_OLDUNREAL="${folder_2_middle_oldunreal}" \
    FOLDER_3_LOWER_UT_ORIGINALS=/3-lower_ut-originals

RUN mkdir -p "$FOLDER_2_MIDDLE_OLDUNREAL" && \
    mv /tmp/OldUnreal_Source/* "$FOLDER_2_MIDDLE_OLDUNREAL" && \
    rm -rf /tmp

EXPOSE 5580/tcp 7777/udp 7778/udp 7779/udp 7780/udp 7781/udp 8777/udp 27500/tcp 27500/udp 27900/tcp 27900/udp

COPY environment-variables.env ${folder_2_middle_oldunreal}
COPY kill-server-on-file-changes.sh ${folder_2_middle_oldunreal}
COPY start-server.sh ${folder_2_middle_oldunreal}

WORKDIR ${folder_2_middle_oldunreal}

CMD ["/bin/bash", "start-server.sh"]