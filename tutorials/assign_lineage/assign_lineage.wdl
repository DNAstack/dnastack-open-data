version 1.0

workflow assign_lineage {
    input {
        Array [File] assemblies
    }

    call create_multifasta {
        input:
            assemblies = assemblies
    }

    call pangolin {
        input:
            multifasta = create_multifasta.multifasta
    }

    output {
        File lineage_assignment = pangolin.lineage_assignment
    }
}

task create_multifasta {
    input {
        Array [File] assemblies
    }

    command <<<
        while read -r fasta_file || [[ -n "$fasta_file" ]]; do
            cat "$fasta_file" >> multifasta.fa
        done < ~{write_lines(assemblies)}
    >>>

    output {
        File multifasta = "multifasta.fa"
    }

    runtime {
        docker: "ubuntu:bionic"
        cpu: 1
        memory: "1 GB"
    }
}

task pangolin {
    input {
        File multifasta
    }

    Int threads = 4

    command <<<
        pangolin --update
        pangolin --update-data

        pangolin \
            --threads ~{threads} \
            ~{multifasta} \
            --output_file lineage_assignment.csv
    >>>

    output {
        File lineage_assignment = "lineage_assignment.csv"
    }

    runtime {
        docker: "dnastack/pangolin:a1f8a3a"
        cpu: threads
        memory: "8 GB"
    }
}
