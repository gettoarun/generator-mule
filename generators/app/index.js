// Generated by CoffeeScript 1.10.0
var CONFIG, MuleGenerator, folderize, fs, generators, muleConfig,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

fs = require('fs');

generators = require('yeoman-generator');

muleConfig = require('./mule-config');

folderize = require('../../common/util').folderize;

CONFIG = muleConfig.CONFIG;

MuleGenerator = (function(superClass) {
  extend(MuleGenerator, superClass);

  function MuleGenerator() {
    var key, ref, ref1, value;
    generators.Base.apply(this, arguments);
    ref = CONFIG["arguments"];
    for (key in ref) {
      value = ref[key];
      this.argument(key, value);
    }
    ref1 = CONFIG.options;
    for (key in ref1) {
      value = ref1[key];
      this.option(key, value);
    }
  }

  MuleGenerator.prototype.prompting = function() {
    var done, questions, self;
    done = this.async();
    this.project = {};
    questions = [];
    self = this;
    questions.push(CONFIG.questions.name(self));
    questions.push(CONFIG.questions.description(self));
    this.prompt(questions, function(answers) {
      self.project.name = self.name || answers.name;
      self.project.description = self.description || answers.description;
      console.log("Project : " + (JSON.stringify(self.project)));
      return done();
    });
    return self;
  };

  MuleGenerator.prototype.writing = function() {
    var done, e, error, targetName, tfStats;
    this.log('Writing...');
    done = this.async();
    targetName = folderize(this.project.mavenize ? this.project.artifact : this.project.name);
    this.log("Creating project folder " + targetName + "...");
    try {
      tfStats = fs.statSync(targetName);
    } catch (error) {
      e = error;
      fs.mkdirSync(targetName);
    }
    this.project.file = targetName;
    this.project.folder = tfStats;
    this.project.generated_at = new Date();
    this.destinationRoot(targetName);
    this.log("File = " + this.project.file);
    this.log("Creating files...");
    this.fs.copyTpl(this.templatePath('../../../templates/mule-non-maven/'), this.destinationPath(), {
      project: this.project
    });
    this.fs.copyTpl(this.templatePath('../../../templates/mule-non-maven/.*'), this.destinationPath(), {
      project: this.project
    });
    return done();
  };

  MuleGenerator.prototype.conflicts = function() {
    var done;
    this.log('Resolving...');
    done = this.async();
    done();
    return this.log("Done!");
  };

  MuleGenerator.prototype.end = function() {
    var done;
    this.log('Cleaning up...');
    done = this.async();
    console.log("Renaming ", this.destinationPath('src/main/app/main-app-flow.xml'), " with ", this.destinationPath("src/main/app/" + this.project.file + ".xml"));
    fs.renameSync(this.destinationPath('src/main/app/main-app-flow.xml'), this.destinationPath("src/main/app/" + this.project.file + ".xml"));
    done();
    return this.log("Done!");
  };

  return MuleGenerator;

})(generators.Base);

module.exports = MuleGenerator;
