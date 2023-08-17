@echo off
rem �����������ղ�νṹ��֯��Ŀ¼
rem ����: Suker
rem �û���Ҫ������ʼ���ºͽ������£�Ȼ��ű����Զ�������Ӧ��Ŀ¼�ṹ��

setlocal enabledelayedexpansion
echo  -------------------------------------------------------------------------------------------------------------
echo        �˽ű���Suker��д�����ڴ����������ղ�νṹ��֯��Ŀ¼�����磺2019��/01��/02�ա�
echo  -------------------------------------------------------------------------------------------------------------
echo        �˽ű��Զ��Ż������ꡢ��С�·����ڡ��������á�
echo  ------------------------------------------------------------------------------------------------------------- 
echo 	��ӡ�����������������������20�����ϣ���ʼѯ���û��Ƿ����ִ�С�
echo  ------------------------------------------------------------------------------------------------------------- 
echo        ��������ʼ���ºͽ������£����磺2019-2023
echo  -------------------------------------------------------------------------------------------------------------
:input
rem ��ʾ�û�������ʼ��ͽ�����
set /p "dateRange=��������ʼ��ͽ�����: "

rem У�������ʽ
set "validFormat=0"
for /f "tokens=1,2 delims=-" %%a in ("!dateRange!") do (
    set "startYear=%%a"
    set "endYear=%%b"
    if "%%a" lss "1000" goto invalid
    if "%%a" gtr "9999" goto invalid
    if "%%b" lss "1000" goto invalid
    if "%%b" gtr "9999" goto invalid
    set "validFormat=1"
)
if !validFormat! equ 0 (
    echo ��������ȷ�ĸ�ʽ�����磺2019-2023
    goto input
)

rem У����ʼ�ͽ�����ݹ�ϵ
if !startYear! gtr !endYear! (
    echo ��ʼ��ݲ��ܴ��ڽ�����ݣ����������롣
    goto input
)

rem ������ݲ��
set /a "yearDifference=endYear - startYear"
if !yearDifference! gtr 20 (
    set /p "continue=��ʼ��ݺͽ���������ϴ��Ƿ����ִ�У� (yes/no): "
    if /i "!continue!" neq "yes" (
        echo �û�ѡ�񲻼��������������
        pause
        exit
    )
)

rem ��ȡ��ǰĿ¼·��
for %%A in ("%cd%") do set "currentDir=%%~A"

rem ѭ��������ݷ�Χ
for /L %%Y in (!startYear!,1,!endYear!) do (
    rem �������Ŀ¼
    mkdir "!currentDir!\%%Y��"
    
    for /L %%M in (1,1,12) do (
        set "month=%%M"
        if %%M LSS 10 set "month=0%%M"
        mkdir "!currentDir!\%%Y��\!month!��"
        
        if %%M equ 2 (
            set /a "leap=%%Y %% 4"
            if !leap! equ 0 (
                set /a "leap=%%Y %% 100"
                if !leap! neq 0 (
                    set "days=29"
                ) else (
                    set /a "leap=%%Y %% 400"
                    if !leap! equ 0 (
                        set "days=29"
                    ) else (
                        set "days=28"
                    )
                )
            ) else (
                set "days=28"
            )
        ) else if %%M equ 4 (
            set "days=30"
        ) else if %%M equ 6 (
            set "days=30"
        ) else if %%M equ 9 (
            set "days=30"
        ) else if %%M equ 11 (
            set "days=30"
        ) else (
            set "days=31"
        )
        
        for /L %%D in (1,1,!days!) do (
            set "day=%%D"
            if %%D LSS 10 set "day=0%%D"
            mkdir "!currentDir!\%%Y��\!month!��\!day!��"
        )
    )
)

echo �ļ��ṹ�����ɣ�
pause
exit

:invalid
echo ��������ȷ�ĸ�ʽ�����磺2019-2023
goto input
