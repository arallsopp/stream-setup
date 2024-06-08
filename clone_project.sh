# generate .ssh key to clone the repository
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub)

# Print the public key and prompt the user to add it to Bitbucket
echo "Below you have your public key. Add it to Bitbucket then press y for us to continue:"
echo "$PUBLIC_KEY"

# Wait for user confirmation
while true; do
    read -p "Have you added the SSH key to Bitbucket? (y/n): " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please add the SSH key to Bitbucket to continue."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Clone the repository
git clone git@bitbucket.org:arallsopp/stream.git ~/stream