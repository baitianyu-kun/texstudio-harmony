import { getLocalStorageTsInterface } from './LocalStorageTsModule';
import { getOhosExportModules, getOhosExportModulesFactories } from './OhosExportModules';
import { getQEmbeddedComponentCreatorTsInterface } from './QEmbeddedComponentCreatorTsModule';

export default class QtUtils {
  static getModulesMapForQt(): object {
    let modules = getOhosExportModules();
    modules['LocalStorage'] = getLocalStorageTsInterface();
    modules['QEmbeddedComponentCreator'] = getQEmbeddedComponentCreatorTsInterface();
    return modules;
  }

  static getModulesFactoriesMapForQt(): object {
    let factories = getOhosExportModulesFactories();
    factories['LocalStorage'] = getLocalStorageTsInterface;
    factories['QEmbeddedComponentCreator'] = getQEmbeddedComponentCreatorTsInterface;
    return factories;
  }
}
