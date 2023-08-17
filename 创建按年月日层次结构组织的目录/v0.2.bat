@echo off
rem 创建按年月日层次结构组织的目录
rem 作者: Suker
rem 用户需要输入起始年月和截至年月，然后脚本会自动创建对应的目录结构。

setlocal enabledelayedexpansion
echo  -------------------------------------------------------------------------------------------------------------
echo        此脚本由Suker编写，用于创建按年月日层次结构组织的目录。例如：2019年/01月/02日。
echo  -------------------------------------------------------------------------------------------------------------
echo        此脚本自动优化了闰年、大小月份日期。即开即用。
echo  ------------------------------------------------------------------------------------------------------------- 
echo 	添加《“防呆”》设计如果年份相差20年以上，开始询问用户是否继续执行。
echo  ------------------------------------------------------------------------------------------------------------- 
echo        请输入起始年月和截至年月，例如：2019-2023
echo  -------------------------------------------------------------------------------------------------------------
:input
rem 提示用户输入起始年和截至年
set /p "dateRange=请输入起始年和截至年: "

rem 校验输入格式
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
    echo 请输入正确的格式，例如：2019-2023
    goto input
)

rem 校验起始和截至年份关系
if !startYear! gtr !endYear! (
    echo 起始年份不能大于截至年份，请重新输入。
    goto input
)

rem 计算年份差距
set /a "yearDifference=endYear - startYear"
if !yearDifference! gtr 20 (
    set /p "continue=起始年份和截至年份相差较大，是否继续执行？ (yes/no): "
    if /i "!continue!" neq "yes" (
        echo 用户选择不继续，程序结束。
        pause
        exit
    )
)

rem 获取当前目录路径
for %%A in ("%cd%") do set "currentDir=%%~A"

rem 循环遍历年份范围
for /L %%Y in (!startYear!,1,!endYear!) do (
    rem 创建年份目录
    mkdir "!currentDir!\%%Y年"
    
    for /L %%M in (1,1,12) do (
        set "month=%%M"
        if %%M LSS 10 set "month=0%%M"
        mkdir "!currentDir!\%%Y年\!month!月"
        
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
            mkdir "!currentDir!\%%Y年\!month!月\!day!日"
        )
    )
)

echo 文件结构已生成！
pause
exit

:invalid
echo 请输入正确的格式，例如：2019-2023
goto input
