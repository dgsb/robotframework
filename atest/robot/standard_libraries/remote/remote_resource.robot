*** Settings ***
Resource          atest_resource.robot

*** Variables ***
${PORT FILE}      %{TEMPDIR}${/}remote_port.txt
${STDOUT FILE}    %{TEMPDIR}${/}remote_output.txt

*** Keywords ***
Run Remote Tests
    [Arguments]    ${tests}    ${server}
    ${port} =    Start Remote Server    ${server}
    Run Tests    --variable PORT:${port}    standard_libraries/remote/${tests}
    Stop Remote Server    ${server}

Start Remote Server
    [Arguments]    ${server}    ${port}=0
    Remove File    ${PORT FILE}
    ${path} =    Normalize Path    ${DATADIR}/standard_libraries/remote/${server}
    Start Process    python    ${path}    ${port}    ${PORT FILE}
    ...    alias=${server}    stdout=${STDOUT FILE}    stderr=STDOUT
    Wait Until Created    ${PORT FILE}    30s
    ${port} =    Get File    ${PORT FILE}
    [Return]    ${port}

Stop Remote Server
    [Arguments]    ${server}
    ${result} =    Terminate Process    handle=${server}
    Log    ${result.stdout}
