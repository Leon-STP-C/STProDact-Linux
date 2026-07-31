# Use node version 22 as our base image
FROM  node:22

# Goes to the app directory
WORKDIR /src

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of our app in the container
COPY . .

# Set port environment variable
ENV PORT=9000

#Expose the port so our computer can access it
EXPOSE 9000 

# Run the app
CMD ["npm", "start"]
