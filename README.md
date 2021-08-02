# Avicenna Theme
A minimal academic page for academics!

**FOR THE DEMO, PLEASE SEE THE LINK BELOW**
[![Screenshot](https://github.com/hadisinaee/avicenna/blob/master/images/youtube.png "Avicenna")](https://youtu.be/rw29ZJJGFIM)

# Features
* Minimal, Responsive, and Clean
* :new: Supports Blog Posts
* :new: Supports News Feed
* Supports Google Analytics
* Supports Social Links
* Supports Publications Listing
* Supports Projects Listing

# How to use `Avicenna`?
To use `Avicenna`, you need to follow three steps:
1. Setup a site with `Avicenna`
2. Customize the site to your needs
3. Build your site and deploy it to your host

The following sections are based on the mentioned steps.
# 1. How to setup a site with `Avicenna`?
There are 2 ways to install `Avicenna`:
1. The first one is just an automated script based on the second approach(recommended). 
2. The sedond one is a step-by-step approach. 

## 1. Automated Script
In this approach, all you need is to replace the `my_cool_page` with your desired name in the following script:

```bash
wget https://raw.githubusercontent.com/hadisinaee/avicenna/master/setup_avicenna.sh && sh setup_avicenna.sh my_cool_page
```

Run the site:
```bash
hugo serve
```

Now, you should be able to see the site at http://localhost:1313

## 2. Step-by-Step Installation
<details>
  <summary>Click to see!</summary>
  
1. You need to install [Hugo][1] first!
2. Create a new site and go to the directory:
```bash
# replace the `my_cool_page` with whatever you want!
hugo new site my_cool_page

# move to your project folder
cd my_cool_page
```

3. Add the stable release of `Avicenna` (the `master` branch) to your `themes` folder:
```bash
git clone -b master git@github.com:hadisinaee/avicenna.git ./themes/avicenna
```

4. Copy the sample site to your project:
```bash
cp -R themes/avicenna/exampleSite/* ./
```

5. Run the site:
```bash
hugo serve
```

Now, you should be able to see the site at [http://localhost:1313](http://localhost:1313/)
</details>

# 2. How to Customize `Avicenna`?

## Start With the `config.toml`
You can start the customization with the `config.toml` file. It's located a the root of your project. In this file, you can set your name, your website URL, googleAnalytics id, etc.

## Adding Your Profile Picture, CV, and Favicon
There is a folder named `static` under the root of your site's folder. Its structure is as follows:

![static_folder](https://github.com/hadisinaee/avicenna/blob/master/static_folder.png)

- **Profile Picture**: Simply replace `profile.png` with your profile file. Please use the same name and extenstion, e.g. `profile.png`. It doesn't work if you use another *name* or *extension*.
- **CV**: You need to put your CV directly under `static` folder. I recommend you to use the name `cv.pdf` for your CV file. Also, if you wanted to use another file name, you would need to change it in your introduction. See Introduction Section.
- **Favicon**: It has the same procedure as your profile picture.

## Content
All files and folders that you need to modify lies in the `content` folder. The folder should look like this

![the content folder structure](https://github.com/hadisinaee/avicenna/blob/master/avicenna_folder.png)

Avicenna theme has three different sections: `Introduction`, `Publications`, and `Projects`. Based on the previous figure, you might have an intuition where you should modify. However, there are some details that I have to provide.

## `Introduction` Section
`Introduction` section is where you put details about yourself, such as your name, profile, interests, etc. To modify the introduction section, you need to edit the `content/about/_index.md` file.

## `Publications` Section
All your publications are stored in `content/publications`. To create a new publication:

```
hugo new publications/your-pub-name.md
```

If was successful, you would see a message similar to the following:

```
YOUR_PROJECT_PATH/content/publications/your-pub-name.md
```

To edit the file, go to `content/publications` and then find your `your-pub-name.md` file and change it.


## Project Section
All your projects are stored in `content/projects`. To create a new project:

```
hugo new projects/your-project-name.md
```

If was successful, you would see a message similar to the following:

```
YOUR_PROJECT_PATH/content/projects/your-project-name.md
```

To edit the file, go to `content/projects` and then find your `your-project-name.md` file and change it.


# 3. How to Deploy `Avicenna`?
1. Make sure you have changed your `baseURL` in the `config.toml` file. It should be the address you want to deploy `Avicenna` on.
2. Run `hugo` in the root of your project. The result will be in the `public` folder in the root of your project.
3. Copy `public` folder and move it your host server.

# Credits
* [Feather Icons](https://feathericons.com/)
* [Academic Icons](https://jpswalsh.github.io/academicons/)
* [Academic Hugo](https://wowchemy.com/templates/) 


[1]: https://gohugo.io/getting-started/installing/
