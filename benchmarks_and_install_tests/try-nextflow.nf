params.str = 'Hello world!'

process splitLetters {
    output:
    path 'chunk_*'

    """
    printf '${params.str}' | split -b 6 - chunk_
    """
}

process convertToUpper {
    input:
    path x

    output:
    stdout

    """
    cat $x | tr '[a-z]' '[A-Z]' && echo "Hola desde \$(hostname)"
    """
}

workflow {
    splitLetters | flatten | convertToUpper | view { it.trim() }
}
