const { promises: fs } = require('fs');
const path = require('path');

const LINE_BREAK = '\n';
const COMMENT_MARKER = '!';

/**
 * 过滤器文件的路径
 * @类型{字符串}
 */
const filterPath = path.resolve(process.argv[2]);

/**
 * 返回文件内容。
 * @param {string} path 文件的路径。
 * @returns {Promise<string>} - Promise 解析为文件内容。
 */
const getFileContent = async (path) => {
    try {
        const content = await fs.readFile(path, 'utf-8');
        return content;
    } catch (error) {
        throw new Error(`读取文件时出错 '${path}' 由于: ${error.message}`);
    }
};

/**
 * 通过修改每条规则来转换过滤器列表的功能
 * @param {string} path - 过滤器文件的路径
 * @returns {Promise<void>} - 文件成功转换时解决的 Promise
 */
const convertFilterList = async (path) => {
    try {
        const fileContent = await getFileContent(path);
        const modifiedContent = fileContent
            .split(LINE_BREAK)
            .map((line) => {
                if (line.startsWith(COMMENT_MARKER)) {
                    return line;
                }
                return `${line}$dnsrewrite=0.0.0.0`;
            })
            .join(LINE_BREAK);
        await fs.writeFile(path, modifiedContent);
    } catch (error) {
        throw new Error(`由于以下原因，规则转换期间出现错误: ${error.message}`);
    }
};

// Call the function to convert the filter list
convertFilterList(filterPath);
