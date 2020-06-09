From minsukjinoaa/fv3-input-data:develop-20200603 AS dataBase
From minsukjinoaa/ci-test-base:ubuntu20.04
#From minsukjinoaa/ci-test-base:centos7

ENV HOME=/home/tester
COPY --chown=tester:tester . $HOME/ufs-weather-model
COPY --from=dataBase --chown=tester:tester /tmp/FV3_input_data $HOME/data/NEMSfv3gfs/develop-20200202/FV3_input_data

USER tester
ENV USER=tester
ARG test_name
ARG build_case
ARG run_case
ENV test_name=$test_name
ENV build_case=$build_case
ENV run_case=$run_case

RUN mkdir $HOME/stmp2 && mkdir $HOME/stmp4
WORKDIR $HOME/ufs-weather-model/tests
RUN ./utest -n $test_name -c $build_case -z
CMD ./utest -n $test_name -c $build_case -x && ./utest -n $test_name -r $run_case -x
