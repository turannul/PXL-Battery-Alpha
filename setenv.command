#!/bin/bash
printf "\033[32m ==> \033[0m Hello this is setup requored stuff to compile PXL\nPlease wait while we are setting up your environment\n"
theoschk(){
if command -v "echo $THEOS" &> /dev/null
echo "THEOS is already installed"
else 
echo "I Guess your theos installation is not correct or not installed?"
echo "See: https://theos.dev/docs/installation"
fi 
}
wgetchk(){
if ! command -v wget &> /dev/null
then
    echo "Installing wget"
    if [[ "$(uname)" == "Linux" ]]; then
        sudo apt-get update && sudo apt-get install wget -y
    elif [[ "$(uname)" == "Darwin" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install wget
    else
        echo "Error: Unsupported operating system."
        exit 99
    fi
else
    echo "wget is already installed."
fi
}
sdkchk(){
if ! test -e "$THEOS/sdks/14.1.zip"
then
printf "\033[33m ==> \033[0m Downloading and installing SDK\n" && wget https://www.dropbox.com/s/jvonok3de24ibsz/14.1.zip -O $THEOS/sdks/14.1.zip > /dev/null 2>&1 && unzip -q $THEOS/sdks/14.1.zip -d $THEOS/sdks/  && rm $THEOS/sdks/14.1.zip 2>&1 && printf "\033[32m ==> \033[0m SDK successfully installed\n" || printf "\n\033[31m ==> \033[0m Oops! something goes wrong."
else
printf "\033[32m ==> \033[0m SDK is already installed\n"
fi
}
viewchk(){
if ! test -e "$THEOS/include/SparkColourPickerView.h"
then
printf "\033[33m ==> \033[0m Downloading and installing Spark Colour Picker Header [1/2]\n" && wget https://raw.githubusercontent.com/SparkDev97/libSparkColourPicker/master/headers/SparkColourPickerView.h -O $THEOS/include/SparkColourPickerView.h > /dev/null 2>&1 && printf "\n\033[32m ==> \033[0m Spark Colour Picker Header [1/2] successfully installed\n" || printf "\n\033[31m ==> \033[0m Oops!! something goes wrong."
else
printf "\033[32m ==> \033[0m Spark Colour Picker Header is already installed\n"
fi
}
utilschk(){
if ! test -e "$THEOS/include/SparkColourPickerUtils.h"
then
printf "\033[33m ==> \033[0m Downloading and installing Spark Colour Picker Header [2/2]\n" && wget https://raw.githubusercontent.com/SparkDev97/libSparkColourPicker/master/headers/SparkColourPickerUtils.h -O $THEOS/include/SparkColourPickerUtils.h > /dev/null 2>&1 && printf "\n\033[32m ==> \033[0m Spark Colour Picker Header [2/2] successfully installed\n" || printf "\n\033[31m ==> \033[0m Oops!! something goes wrong."
else
printf "\033[32m ==> \033[0m Spark Colour Picker Utils Header is already installed\n"
fi
}
pickerchk(){
if ! test -e "$THEOS/lib/libsparkcolourpicker.dylib"
then
printf "\033[33m ==> \033[0m Downloading and installing SparkColourPicker Library\n" && wget https://raw.githubusercontent.com/SparkDev97/libSparkColourPicker/master/lib/libsparkcolourpicker.dylib -O $THEOS/lib/libsparkcolourpicker.dylib > /dev/null 2>&1 && chmod 755 $THEOS/lib/libsparkcolourpicker.dylib && printf "\n\033[32m ==> \033[0m Spark Colour Picker Library successfully installed\n" || printf "\n\033[31m ==> \033[0m Oops!! something goes wrong."
else
printf "\033[32m ==> \033[0m SparkColourPicker Library is already installed\n"
fi
}
theoschk
wgetchk
sdkchk
viewchk
utilschk
pickerchk
printf "\033[32m ==> \033[0m All done! You can now compile PXL\n"
```