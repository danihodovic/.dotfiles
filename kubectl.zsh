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

function kubeexec {
  pod=$(kubectl get pods | fzf --ansi --exact --tac)
  pod_name=$(echo $pod | awk '{print $1}')
  if [ -n $pod_name ]; then
    kubectl exec -it $@ $pod_name bash || sh
  fi
}

function kubelog {
  pod=$(kubectl get pods | fzf --ansi --exact --tac)
  pod_name=$(echo $pod | awk '{print $1}')
  if [ -n $pod_name ]; then
    kubectl logs $@ $pod_name
  fi
}
