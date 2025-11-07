#!/bin/bash
echo "=== ArgoCD 访问信息 ==="

# 获取节点IP和端口
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc -n argocd argocd-server -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')

# 获取密码
PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>/dev/null | base64 -d 2>/dev/null)

echo "访问地址: https://$NODE_IP:$NODE_PORT"
echo "用户名: admin"
if [ -n "$PASSWORD" ]; then
    echo "密码: $PASSWORD"
else
    echo "密码: 无法自动获取，请运行以下命令手动获取:"
    echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
fi

echo ""
echo "如果无法访问，请检查:"
echo "1. 防火墙是否允许访问端口 $NODE_PORT"
echo "2. 浏览器是否信任自签名证书（首次访问需要接受安全警告）"
