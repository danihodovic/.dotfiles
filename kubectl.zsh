function kubecontext {
  formatted_cluster_output=$(
    kubectl config view -o json | \
    jq -r '.contexts[] | [.name, .context.cluster] | @tsv' | \
    awk 'BEGIN{print "NAME\tCLUSTER"};{print};' | \
    column -t
  )
  chosen_cluster=$(
    echo $formatted_cluster_output | \
    fzf --ansi --exact --tac | \
    awk '{print $1}'
  )
  if [ -n $chosen_cluster ]; then
    kubectl config use-context $chosen_cluster
  fi
}
alias kcontext=kubecontext

function kubeexec {
  pod=$(kubectl get pods | fzf --ansi --exact --tac)
  pod_name=$(echo $pod | awk '{print $1}')
  if [ -n $pod_name ]; then
    cmd="kubectl exec -it $@ $pod_name bash"
    print -s $cmd
    eval $cmd
  fi
}
alias kexec=kubeexec

function kubelogs {
  pod=$(kubectl get pods | fzf --ansi --exact --tac)
  pod_name=$(echo $pod | awk '{print $1}')
  if [ -n $pod_name ]; then
    cmd="kubectl logs $@ $pod_name"
    print -s $cmd
    eval $cmd
  fi
}
alias klogs=kubelogs
