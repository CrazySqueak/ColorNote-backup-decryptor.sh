#!/bin/bash
WK_DIR=$(pwd)
CBD_DIR="$WK_DIR/decryptor"

if [ -d "$CBD_DIR" ]
then
    echo "Updating colornote backup decryptor..."
    cd "$CBD_DIR"
    git fetch && git pull
    [ $? -eq 0 ] && echo "Update successful." || echo "Update failed. Continuing anyways..."
else
    echo "Downloading colornote backup decryptor..."
    git clone https://github.com/olejorgenb/ColorNote-backup-decryptor.git "$CBD_DIR"
    echo "Done."
fi

cd "$CBD_DIR"

JAVA_CMD="java -jar colornote-decrypt.jar"

echo "Determining java version..."
JAVA_ERR=$($JAVA_CMD < /dev/null 2>&1 >/dev/null)

if echo "$JAVA_ERR" | grep -Fq "java: command not found"
then
    echo "Java is not installed, or not on PATH!"
    echo "Please ensure you have the JRE installed and on PATH."
    read -p "Press enter to exit. "
    exit 1
fi
if echo "$JAVA_ERR" | grep -Fq "java.lang.UnsupportedClassVersionError"
then
    echo "Your java version is too low!"
    echo "This requires JRE version 1.8 or above!"
    read -p "Press enter to exit. "
    exit 1
fi

if echo "$JAVA_ERR" | grep -Fq "java.util.jar.JarException"
then
    echo "Oracle Java detected. Using classpath fix."
    
    # Guess classpath separator
    guess_classpath_sep(){
        echo "Testing Unix-style classpath..."
        JAVA_CMD="java -cp lib/bcprov-jdk15on-154.jar:lib/bcpkix-jdk15on-154.jar:bin ColorNoteBackupDecrypt"
        JAVA_ERR=$($JAVA_CMD < /dev/null 2>&1 >/dev/null)
        echo "$JAVA_ERR" | grep -Fq "java.lang.ClassNotFoundException"
        [[ $? -ne 0 ]] && return 0;
        
        echo "Testing Windows-style classpath..."
        JAVA_CMD="java -cp lib/bcprov-jdk15on-154.jar;lib/bcpkix-jdk15on-154.jar;bin ColorNoteBackupDecrypt"
        JAVA_ERR=$($JAVA_CMD < /dev/null 2>&1 >/dev/null)
        echo "$JAVA_ERR" | grep -Fq "java.lang.ClassNotFoundException"
        [[ $? -ne 0 ]] && return 0;
        
        echo "Unable to determine classpath arguments."
        echo "You're on your own."
        read -p "Press enter to exit. "
        return 1
    }
    guess_classpath_sep || exit 1;
    echo "Determined classpath separator successfully."
fi

cd "$WK_DIR"

read -p "Enter path to backup (input) file (.backup, .dat, .doc): " BACKUP_FILE
read -p "Enter path to output to (.json): " OUTPUT_PATH
read -p "Enter ColorNote master password (0000 is the colornote default): " PASSWORD

BACKUP_FILE=$(realpath "$BACKUP_FILE")
OUTPUT_PATH=$(realpath "$OUTPUT_PATH")
TEMP_PATH="$OUTPUT_PATH.tmp"

cd "$CBD_DIR"

decrypt_backup_v1(){
    echo "Attempting V1 decryption..."
    $JAVA_CMD "$PASSWORD" < "$BACKUP_FILE" > "$TEMP_PATH" || { echo "Failed."; return 1; }
    echo "Success."
    return 0;
}
decrypt_backup_v2(){
    echo "Attempting V2 decryption..."
    $JAVA_CMD "$PASSWORD" 28 < "$BACKUP_FILE" > "$TEMP_PATH" || { echo "Failed."; return 1; }
    echo "Success."
    return 0;
}
pwd
decrypt_backup_v1 || decrypt_backup_v2 || { echo "Unable to decrypt backup!Please make sure that you have entered the correct password.\nIf you have, then this may be an issue with the decryptor.\nPlease report this issue to https://github.com/olejorgenb/ColorNote-backup-decryptor/issues/"; read -p "Press enter to exit. "; exit 2; }

echo "Decryption has completed successfully."
echo "Cleaning up decrypted file..."

cleanup_v3(){
    # Check for presence of python3
    python3 -c "import sys; sys.exit(0)" >/dev/null 2>/dev/null
    if [[ $? -ne 0 ]]
    then
        # Check for windows python (which is `py` instead of `python3` for some godforsaken reason)
        py -c "import sys; sys.exit(0)" >/dev/null 2>/dev/null
        if [[ $? -ne 0 ]]
        then
            echo "WARN: Python 3 is not installed. The resulting json will not be prettified."
            echo "Modifying cleanup script to reflect environment..."
            cat "$CBD_DIR/fixup-v3" | sed 's/[|] python3.*>/>/g' > "$WK_DIR/fixup-v3-fixed"
            FIX_V3="$WK_DIR/fixup-v3-fixed"
        else
            echo "Detected python installation on Windows."
            echo "Modifying cleanup script to reflect environment..."
            cat "$CBD_DIR/fixup-v3" | sed 's/python3/py/g' > "$WK_DIR/fixup-v3-fixed"
            FIX_V3="$WK_DIR/fixup-v3-fixed"
        fi
    else
        FIX_V3="$CBD_DIR/fixup-v3"
    fi
    echo "Attempting cleanup script V3..."
    $FIX_V3 "$TEMP_PATH" "$OUTPUT_PATH" || { echo "Failed."; return 1; }
    echo "Success."
    return 0;
}
cleanup_v2(){
    echo "Attempting cleanup script V2..."
    "$CBD_DIR/fixup-v2" < "$TEMP_PATH" > "$OUTPUT_PATH" || { echo "Failed."; return 1; }
    echo "Success."
    return 0;
}
cleanup_v1(){
    echo "Attempting cleanup script V1..."
    "$CBD_DIR/fixup-v1" < "$TEMP_PATH" > "$OUTPUT_PATH" || { echo "Failed."; return 1; }
    echo "Success."
    return 0;
}

cleanup_v3 || cleanup_v2 || cleanup_v1 || { mv "$TEMP_PATH" "$OUTPUT_PATH"; echo "ERR: None of the cleanup scripts worked. The backup has been correctly decrypted, but the output file will need to be cleaned up manually by the user."; exit 3; }

echo "Your ColorNote backup has been successfully decrypted and exported!"
exit 0
#echo "(Note that the format may vary depending on the cleanup script used.)"
#echo "(If cleanup V1 or V2 was used, you may have to manually clean some extra garbage bytes before you can use the resulting data.)"
#echo "(If cleanup V3 was used, you're all set and can import the JSON into anything that supports it, or open it manually with a text editor.)"