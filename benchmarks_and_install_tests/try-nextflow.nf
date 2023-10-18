params.str = '1234567890'

process splitLetters {
    output:
    path 'chunk_*'

    """
    printf '${params.str}' | split -b 1 - chunk_
    """
}

process convertToUpper {
    input:
    path x

    output:
    stdout

    """
    cat $x && echo " Hola desde \$(hostname)"
    """
}

workflow {
    splitLetters | flatten | convertToUpper | view { it.trim() }
}
