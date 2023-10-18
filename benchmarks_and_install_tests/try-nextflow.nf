params.str = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'

process splitLetters {
    output:
    path 'chunk_*'

    """
    sleep 10 && printf '${params.str}' | split -b 1 - chunk_
    """
}

process convertToUpper {
    input:
    path x

    output:
    stdout

    """
    sleep 30 && cat $x && echo " Hola desde \$(hostname)"
    """
}

workflow {
    splitLetters | flatten | convertToUpper | view { it.trim() }
}
