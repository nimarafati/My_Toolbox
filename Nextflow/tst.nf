// Enable DSL2 for more powerful functionality
nextflow.enable.dsl = 2


params.intermediateDir= '/home/nimar/nextflow_tutorial/intermediate/'
workflow {
    Channel
    .fromFilePairs('/domus/h1/nimar/nextflow_tutorial/fastq/*{1,2}.fq')
    test()
}

process test {
    publishDir '${params.intermediateDir}FastQC/',
    mode: 'move'

    output:
    path 'tst.txt'
    script:
    """
        echo 'intermediateDir directory is: ${params.intermediateDir}/FastQC' >tst.txt
    """  

}
